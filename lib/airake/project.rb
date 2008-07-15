module Airake

  class Project
  
    attr_reader :env, :base_dir, :src_dirs, :lib_dir, :swf_path, :debug
    
    # Create project.
    #
    # ==== Options:
    # +env+: Environment, such as development, test, production. Defaults to ENV["AIRAKE_ENV"].
    # +base_dir+: Base (project) directory. Defaults to ENV["AIRAKE_ROOT"]
    # +options+: If nil, options are loaded from airake.yml in root. (All paths relative to base directory)
    # - +src_dirs+: Paths to source
    # - +lib_dir+: Path to lib directory
    # - +swf_path+: Path to SWF file
    # - +debug+: "true" or "false"
    # 
    # ==== More options:
    # * mxmlc_path
    # * asdoc_path
    # * mxmlc_extra_opts
    # * asdoc_extra_opts
    #     
    def initialize(env = nil, base_dir = nil, options = nil)            
      @env = env
      @env = ENV["AIRAKE_ENV"] if @env.nil?      
      base_dir = ENV["AIRAKE_ROOT"] if base_dir.nil?
      raise "Need to specify an AIRAKE_ROOT (project root)" if base_dir.blank?
      
      @base_dir = base_dir      
      
      if options.nil?
        conf_path = File.join(base_dir, "airake.yml")
        unless File.exist?(conf_path)
          raise <<-EOS 
        
            You are missing your #{conf_path} configuration file.
          
            For existing projects, please regenerate an airake project and look at Rakefile and airake.yml for an example.
          
          EOS
        end
        
        options = YAML.load_file(File.join(base_dir, "airake.yml"))
        env_options = options[env]
        options = options.merge(env_options) if env_options
        options.symbolize_keys!
      end
      
      load(options)
            
      ensure_exists([ *@src_dirs ])
    end
    
    # Load options
    def load(options = {})
      @src_dirs = []      
      @src_dirs = options[:src_dirs].collect { |src_dir| File.join(base_dir, src_dir) } if options[:src_dirs]
        
      @lib_dir = File.join(base_dir, options[:lib_dir]) if options[:lib_dir]      
      @swf_path = File.join(base_dir, options[:swf_path])      
      
      with_keyed_options([ :debug ], options)      
    end
    
    # AS docs
    def asdoc
      options = { :lib_dir => @lib_dir, :src_dirs => @src_dirs, :asdoc_extra_opts => @asdoc_extra_opts,
        :asdoc_path => @asdoc_path }        
      Airake::Commands::Asdoc.new(options)
    end
    
    # Remove files
    def clean
      FileUtils.rm(@swf_path, :verbose => true) if File.exist?(@swf_path)
    end

  protected
        
    # Load options into instance vars
    def with_keyed_options(keys, options) 
      keys.each do |key|        
        value = options[key]
        instance_variable_set("@#{key}", value) if value
      end
    end
    
    def ensure_exists(paths)
      paths.each do |path|
        raise "Path not found: #{path}" unless File.exist?(path)
      end
    end
    
  end
  
end