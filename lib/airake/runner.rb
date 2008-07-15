module Airake #:nodoc:
  
  # Runs commands
  class Runner
    
    # Lifted from http://groups.google.com/group/comp.lang.ruby/browse_thread/thread/a274d5d47feae95
    attr_reader :output, :cmd, :took, :process

    def initialize(cmd)
      @cmd = RUBY_PLATFORM =~ /win32/ ? "cmd.exe /c #{cmd} 2>&1" : "#{cmd} 2>&1"
    end
    
    def run(verbose = true)
      puts "Running: #{@cmd}" if verbose
    
      t1 = Time.now
      IO.popen(@cmd) do |f| 
        while s = f.read(1)
          printf s
          STDOUT.flush
        end
      end
      @process = $?
      @took = Time.now - t1
      
      if verbose
        success? or fail
        #puts "Took %.2fs" % [ @took ]
      end
      
    end    
    
    def fail
      raise <<-EOS 
[exited=#{exit_code}, pid=#{pid}] failed:
         
#{cmd}
          
EOS
    end
    
    def run?
      !@process.nil?
    end
    
    def exit_code
      @process ? @process.exitstatus : nil
    end
    
    def pid
      @process ? @process.pid : nil
    end

    def success?
      return run? && @process.success?
    end
    
    # Run airake command
    def self.run(command, method, *args)
      runner = self.new(command.send(method, *args))
      runner.run
    end
    
  end
  
end