module Airake
  
  module Projects
        
    # Project for AIR application
    class Air < Airake::Project
      
      attr_reader :mxml_path, :appxml_path, :air_path
      attr_reader :assets, :certificate          
      
      # Load options
      #
      # +options+: If nil, options are loaded from airake.yml in root. (All paths relative to base directory)      
      # - +air_path+: Path to AIR file
      # - +mxml_path+: Path to the ProjectName.mxml
      # - +appxml_path+: Path to application descriptor    
      # - +assets+: Path to assets
      # - +certificate+: Path to certificate      
      #
      # ==== More options
      # * adt_path
      # * adl_path    
      # * adt_extra_opts
      # * adl_extra_opts
      #            
      def load(options = {})
        super(options)
        
        @air_path = File.join(base_dir, options[:air_path])      
        @mxml_path = File.join(base_dir, options[:mxml_path])      
        @appxml_path = File.join(base_dir, options[:appxml_path])
        
        with_keyed_options([ :assets, :certificate, :mxmlc_path, :adt_path, :adl_path, :asdoc_path, 
          :mxmlc_extra_opts, :adt_extra_opts, :adl_extra_opts, :asdoc_extra_opts ], options)

        ensure_exists([ @mxml_path, @appxml_path ])
      end      
      
      # Flex compiler command (under AIR) for this project
      def amxmlc
        mxmlc({ :config_name => "air" })
      end
      
      # Flex compiler command for this project
      def mxmlc(options = {})
        options = options.merge({ :swf_path => @swf_path, :target_file => @mxml_path, :lib_dir => @lib_dir, 
          :src_dirs => @src_dirs, :debug => @debug, :mxmlc_extra_opts => @mxmlc_extra_opts, 
          :mxmlc_path => @mxmlc_path })

        Airake::Commands::Mxmlc.new(options)
      end

      # ADL command for this project
      def adl
        options = { :appxml_path => @appxml_path, :base_dir => @base_dir, :adl_extra_opts => @adl_extra_opts,
          :adl_path => @adl_path }
        Airake::Commands::Adl.new(options)
      end

      # ADT command for this project
      def adt
        options = { :air_path => @air_path, :appxml_path => @appxml_path, :swf_path => @swf_path, 
          :base_dir => @base_dir, :assets => @assets, :cert => @certificate, :adt_extra_opts => @adt_extra_opts,
          :adt_path => @adt_path }
        Airake::Commands::Adt.new(options)
      end
      
      def clean
        paths = [ @swf_path, @air_path ]
        paths.each do |path|
          FileUtils.rm(path, :verbose => true) if File.exist?(path)
        end
      end
    end
    
  end
  
end