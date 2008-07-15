namespace :air do
    
  desc "Compile"
  task :compile => :clean do
    begin
      project = Airake::Projects::Air.new
      fcsh = PatternPark::FCSH.new_from_rake(ENV)
      fcsh.execute([ project.base_dir, project.amxmlc.compile ])      
    rescue PatternPark::FCSHConnectError => e
      puts "Cannot connect to FCSHD (start by running: rake fcsh:start); Continuing compilation..."
      Airake::Runner.run(project.amxmlc, :compile)
    end
  end

  desc "Test"
  task :test do
    ENV["AIRAKE_ENV"] = "test"
    Rake::Task["air:clean"].invoke
    
    test_project = Airake::Projects::Air.new
    Airake::Runner.run(test_project.amxmlc, :compile)
    Airake::Runner.run(test_project.adl, :launch)
  end
  
  desc "Generate certificate"
  task :certificate do 
    
    pfx_file = ENV["CERTIFICATE"]
    
    unless pfx_file
      project = Airake::Projects::Air.new    
      pfx_file = project.certificate
    end
    
    if pfx_file.blank? || pfx_file == "path/to/certificate.pfx"
      print "Certificate file (to create; e.g. cert.pfx): "
      pfx_file = STDIN.gets.chomp!      
    end  
    
    if File.exist?(pfx_file)
      raise <<-EOS
        Certificate file exists at '#{pfx_file}'. If you want to generate a new certificate, please delete it first.
        You can override the setting in the Rakefile or on the command line: rake air:certificate CERTIFICATE=path.pfx
      EOS
                    
    end
    
    puts "Will generate a certificate file at: #{pfx_file}"
    
    project = Airake::Projects::Air.new
    optionals = {}

    print "Specify common name (e.g. SelfSign, ADigitalID) [SelfSign]: "
    cn = STDIN.gets.chomp!
    cn = "SelfSign" if cn.blank? 

    print "Key type (e.g. 1024-RSA, 2048-RSA) [1024-RSA]:"
    key_type = STDIN.gets.chomp!
    key_type = "1024-RSA" if key_type.blank? 

    print "Organization name (optional; e.g ducktyper.com): "
    input = STDIN.gets.chomp!
    optionals[:org] = "\"#{input}\"" unless input.blank?    

    print "Organization unit (optional; e.g QE): "
    optionals[:org_unit] = STDIN.gets.chomp!

    print "Country (optional; e.g. US): "
    optionals[:country] = STDIN.gets.chomp!

    print "Password: "
    password = STDIN.gets.chomp!

    Airake::Runner.run(project.adt, :certificate, cn, pfx_file, key_type, password, optionals)
  end
  
  # Check certificate configuration for package task
  task :check_certificate do 
    pfx_file = ENV["CERTIFICATE"]
    
    unless pfx_file
      project = Airake::Projects::Air.new    
      pfx_file = project.certificate
    end
    
    if pfx_file.blank? || pfx_file == "path/to/certificate.pfx"
      raise <<-EOS
          No certificate path found (or not set). Please specify ENV[\"CERTIFICATE\"] = \"path/to/certificate.pfx\" in Rakefile. Or certificate: path/to/cert.pfx in airake.yml.
          If you don't have a certificate run rake air:certificate to generate one.
      EOS
    end
    
    raise "Certificate does not exist yet. Run rake air:certificate to generate one at #{pfx_file}" unless File.exist?(pfx_file)
  end

  desc "Package"
  task :package => [ :check_certificate, :compile, :package_only ] do
    
    if ENV["AIRAKE_ENV"] != "production"
      puts <<-EOS
      
        You packaged under the environment: #{ENV["AIRAKE_ENV"]}.
        
        You might want to package by: AIRAKE_ENV=production rake air:package 
      
      EOS
    end    
  end
    
  desc "Package only"
  task :package_only do
    project = Airake::Projects::Air.new
    Airake::Runner.run(project.adt, :package)
  end
  
  task :set_debug do
    ENV["DEBUG"] = "true" unless ENV.has_key?("DEBUG")
  end

  desc "Launch ADL"
  task :adl => [ :set_debug, :compile, :adl_only ] do; end
  
  desc "Launch ADL only"
  task :adl_only do 
    project = Airake::Projects::Air.new
    Airake::Runner.run(project.adl, :launch)
  end
  
  desc "Compile component"
  task :acompc do
    source_path = ENV["SOURCE"]
    output_path = ENV["OUTPUT"]
    packages = ENV["PACKAGES"]
    
    if source_path.blank? and output_path.blank? and packages.blank?
      puts <<-EOS
        You can run without input by specifying the environment variables, e.g.:
        
          rake air:acompc SOURCE=src/ OUTPUT=Foo.swc PACKAGES="com.foo.utils com.bar.baz"
      
      EOS
    end
    
    if source_path.blank?      
      print "Source path [src]: "
      source_path = STDIN.gets.chomp!
      source_path = "src" if source_path.blank?
    end

    if output_path.blank?
      print "Output path (e.g. Foo.swc): "
      output_path = STDIN.gets.chomp!
      raise "Invalid output path" if output_path.blank?
    end

    if packages.blank?
      print "Packages (e.g. com.airake.utils com.airake.foo): "
      packages = STDIN.gets.chomp!
      raise "Invalid packages" if packages.blank?
    end
    
    Airake::Runner.run(Airake::Commands::Acompc.new(:source_path => source_path, :include_packages => packages.split(" "), :output_path => output_path), :compile)
  end
  
  desc "Docs"
  task :docs do
    project = Airake::Projects::Air.new
    Airake::Runner.run(project.asdoc, :generate)
  end
  
  desc "Clean"
  task :clean do 
    project = Airake::Projects::Air.new
    project.clean
  end
  
end