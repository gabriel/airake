#!/usr/bin/env ruby
require 'rubygems'
require 'socket'
require 'open3'

module PatternPark

  class FCSHD < Hash
    include Daemonize
    
    attr_reader :instances, :fcsh_path    
    attr_accessor :kill_process, :start_process

    def initialize(ip = nil, port = nil)
      @fcsh_path = "fcsh" 

      @instances = Hash.new
      @ip = ip.nil? ? "127.0.0.1" : ip
      @port = port.nil? ? 20569 : port
      open(@ip, @port)
      start
    end
    
    def open(ip, port)
      @compile_commands = {}
      @socket = TCPServer.new(@ip, @port)
      @socket.setsockopt(Socket::SOL_SOCKET, Socket::TCP_NODELAY, true)
      puts ">> [FCSHD] Started on #{@ip}:#{@port}"
    end
    
    def start
      daemonize()
      loop do
        session = @socket.accept
        dir = session.gets
        dir = dir.split("\n").join("")
        if (dir == 'SIGHUP')
          stop(session)
          return
        end
        command = session.gets
        execute(session, dir, command)
        session.close
        sleep 0.75
      end
    end
    
    def stop(io)
      io.puts ">> [FCSHD] Terminating daemon now"
      fcsh.puts "quit"
      @socket.close
      exit
    end
        
    def get_fcsh(io, path)
      if(instances[path].nil?)
        fcsh = FCSHProcess.new(fcsh_path, path)
        fcsh.read
        instances[path] = fcsh
      end
      return instances[path]
    end
    
    def execute(io, path, command)
      io.puts "[FCSHD] #{path}"
      io.puts "[FCSHD] #{command}"
      begin
        fcsh = get_fcsh(io, path)
      rescue => e
        io.puts "[ERROR] Unable to launch fcsh: #{e.message}: #{e.backtrace[0..5].join("\n")}"
        exit
      end

      cmd = @compile_commands[command]
      msg = command
      if (!cmd.nil? && cmd.path == path)
        msg = "compile #{cmd.index}"
      end
      
      compile_errors = false
      e = Thread.new {
        while line = fcsh.e.gets
          if line.strip.empty?
            io.puts " "
          elsif line =~ /.?: Warning: .?/
            io.puts "[FCSH WARNING] #{line}"
          else
            io.puts "[FCSH ERROR] #{line}"
            compile_errors = true            
          end
        end
      }

      fcsh.puts msg
      io.puts fcsh.read
      
      e.kill unless compile_errors

      # Store the successful compilation
      if (cmd.nil? && !compile_errors)
        cmd = CompileCommand.new(command, path)
        @compile_commands[command] = cmd
        cmd.index = @compile_commands.size
      end
    end
    
    def self.start_from_rake(env, default_ip = "127.0.0.1", default_port = 20569)
      fcsh_ip = env["FCSH_IP"] || default_ip
      fcsh_port = (env["FCSH_PORT"] || default_port).to_i
      self.new(fcsh_ip, fcsh_port)
    end
  end

  class FCSHProcess
    attr_reader :path, :r, :w, :e
    
    def initialize(target, path)
      @target = target
      @path = path
      start = Dir.pwd
      Dir.chdir(path)
      @w, @r, @e = Open3.popen3(target)
      Dir.chdir(start)
    end
    
    def puts(msg)
      @w.puts(msg)
    end

    def read
      line = ''
      response = ''
      while(!r.eof?)
        char = r.getc.chr
        line += char
        if (line == '(fcsh)')
          response += "[PROMPT] #{line}"
          break
        end
        if (char == "\n")
          response += "[FCSH] #{line}"
          line = ''
        end
      end
      return response
    end
    
  end
  
  class CompileCommand
    attr_accessor :index, :path, :command
    
    def initialize(command, path)
      @command, @path = command, path
    end
  end
end
