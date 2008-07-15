namespace :fcsh do

  desc "Start the FCSHD process (or use air:fcshd)"
  task :start do  
    puts "Starting FCSHD..."
    PatternPark::FCSHD.start_from_rake(ENV)
  end
    
  desc "Stop the FCSHD process"
  task :stop do
    begin
      fcsh = PatternPark::FCSH.new_from_rake(ENV)
      fcsh.stop
    rescue
      puts "Could not stop FCSHD"
    end
  end

  desc "Restart the FCSHD process"
  task :restart => [ :stop, :sleep, :start ]
  
  task :sleep do
    sleep 2
  end
  
end