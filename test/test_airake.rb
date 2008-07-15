require File.dirname(__FILE__) + '/test_helper.rb'

class TestAirake < Test::Unit::TestCase

  def setup
  end
  
  def teardown
    FileUtils.rm_rf("#{run_task_dir}/bin/*", :verbose => true)
    FileUtils.rm_rf("#{run_task_dir}/doc", :verbose => true)
  end
  
  def run_task(run)
    system("cd #{run_task_dir}; rake #{run} --trace") || fail
  end  
  
  def run_task_dir
    File.dirname(__FILE__) + "/Test\\ App"
  end

  def test_adl
    run_task("adl")
  end
  
  def test_compile
    run_task("compile")
  end
  
  def test_test
    run_task("test")
  end
  
  def test_clean
    run_task("clean")
  end
  
  def test_docs    
    run_task("docs")    
  end
  
  def test_acompc
    run_task("acompc SOURCE=src OUTPUT=bin/Foo.swc PACKAGES=\"com.test\"")
  end
  
  def test_package
    puts <<-EOS
    
      Running package test. You will need to enter in the password: 'test'
    
    EOS
    run_task("package")
  end
  

end
