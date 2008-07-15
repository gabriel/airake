class AirakeGenerator < RubiGen::Base
  
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])
  
  attr_reader :name, :app_name, :title, :url, :description, :show_buttons
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty? || args.size < 1
    @destination_root = File.expand_path(args.shift)
    @name = base_name
    @app_name = @name.gsub(/\s+/, "").camelize
    @title = @name
    @url = "http://airake.rubyforge.org/resources.html"
    @description = "Put description here"
    @show_buttons = true
    extract_options
    
    @source_root = File.join(File.dirname(__FILE__), "..", "shared")
  end

  def manifest
    script_options = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }
    
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''      
      BASEDIRS.each { |path| m.directory path }

      m.file "../airake/templates/README", "README"
      
      # Lib
      m.file "lib/flexunit-08.30.2007.swc", "lib/flexunit-08.30.2007.swc"
      m.file "lib/corelib-08.30.2007.swc", "lib/corelib-08.30.2007.swc"
      
      # Test
      m.file "test/Test-app.xml", "test/Test-app.xml"
      m.file "test/Test.mxml", "test/Test.mxml"
      m.directory "test/suite"
      m.file "test/suite/AllTests.as", "test/suite/AllTests.as"      
      
      m.template "Rakefile", "Rakefile"
      m.template "descriptor_1.xml", "src/#{app_name}-app.xml"
      m.template "application.mxml", "src/#{app_name}.mxml"
      m.template "airake.yml", "airake.yml"
      
      # Icons
      m.directory "src/assets/app_icons"
      m.file "icons/Web.png", "src/assets/app_icons/icon_128.png"
      
      m.dependency "install_rubigen_scripts", [destination_root, "air", "airake"], :shebang => options[:shebang]
      
    end
  end

  protected
    def banner
      <<-EOS
Creates an AIR project scaffold.

USAGE: #{spec.name} [path/to/AppName]
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end

    # Installation skeleton.  Intermediate directories are automatically
    # created so don't sweat their absence here.
    BASEDIRS = %w(
      bin
      lib
      src
      script
      test
    )
end