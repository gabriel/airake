=begin
Copyright (c) 2007 Pattern Park

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end
require 'socket'

module PatternPark

  class FCSHError < StandardError; end
  class FCSHConnectError < FCSHError; end  
  class FCSHCompileError < FCSHError; end

  class FCSH
  
    attr_accessor :ip, :port

    def initialize(ip = nil, port = nil)
      @ip = ip
      @port = port
    end
  
    def stop
      begin
        @socket = TCPSocket.open(@ip, @port) do |s|
          s.puts 'SIGHUP'
          s.close_write
          while(line = s.gets)
            puts line
          end
        end
      rescue StandardError => e
        raise FCSHError.new("[FCSH ERROR] Was unable to connect to a running fcsh process for stopping")
      end
    end
  
    def execute(args)
      start_time = Time.now

      error_found = false
      warning_found = false
      begin
        @socket = TCPSocket.open(@ip, @port) do |s|
          puts ">> Opened connection to fcshd on #{@ip}:#{@port}"
          s.puts args
          s.close_write
          while line = s.gets
            break if line =~ /^\[PROMPT\]/
            error_found = true if line =~ /^\[FCSH ERROR\]/
            warning_found = true if line =~ /^\[FCSH WARNING\]/
            puts line             
          end
        end
      rescue StandardError => e
        raise FCSHConnectError.new("[FCSH] Unable to connect to FCSHD process")
      end
    
      raise FCSHCompileError.new("[ERROR] Compile error encountered") if error_found

      end_time = Time.now - start_time
      puts "[FCSH] Compilation complete in: #{end_time} seconds"
    end
    
    def self.new_from_rake(env, default_ip = "127.0.0.1", default_port = 20569)
      fcsh_ip = env["FCSH_IP"] || default_ip
      fcsh_port = (env["FCSH_PORT"] || default_port).to_i
      self.new(fcsh_ip, fcsh_port)
    end
    
  end  
end
