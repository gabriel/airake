require File.dirname(__FILE__) + '/test_helper.rb'

class TestRunner < Test::Unit::TestCase

  
  def test_run
    
    adt = Airake::Commands::Adt.new
    
    cert = adt.certificate("cm", "test.pfx", "1024-RSA", "pass")
    
    Airake::Runner.new(cert).run
    
  end
  
  
end
