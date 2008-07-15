module Airake
  
  module Projects
    
    # Project for Flash
    class Flash < Airake::Project
      
      attr_reader :target_file

      # Load options
      #
      # +options+: If nil, options are loaded from airake.yml in root. (All paths relative to base directory)      
      # - +target_file+: Path to target file
      #
      def load(options = {})
        super(options)
        with_keyed_options([ :target_file ], options)
        ensure_exists([ @target_file ])
      end
      
      # Flex compiler command for this project
      def mxmlc(options = {})
        options = options.merge({ :swf_path => @swf_path, :target_file => @target_file, :lib_dir => @lib_dir, 
          :src_dirs => @src_dirs, :debug => @debug, :mxmlc_extra_opts => @mxmlc_extra_opts, 
          :mxmlc_path => @mxmlc_path })

        Airake::Commands::Mxmlc.new(options)
      end
      
    end
    
  end
  
end