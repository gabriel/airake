namespace :flash do
    
  desc "Compile (on flash)"
  task :compile => :clean do
    begin
      project = Airake::Projects::Flash.new      
      Airake::Runner.run(project.mxmlc, :compile)
    end
  end
  
  desc "Clean"
  task :clean do 
    project = Airake::Projects::Flash.new
    project.clean
  end
  
  desc "Run"
  task :run do
    # TODO
  end
  
end