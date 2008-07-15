require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

# Load airake (why not?)
require 'lib/airake'

task :test_runner do
  
  runner = Airake::Runner.new("rake --tasks")
  runner.run
  
end