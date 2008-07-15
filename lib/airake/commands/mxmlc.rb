module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # MXMLC (MXML compiler)
    class Mxmlc < Base
      
      attr_reader :mxmlc_path, :mxmlc_extra_opts, :swf_path, :target_file, :lib_dir, :src_dirs, :debug
      attr_reader :config_name
      
      # Create MXMLC command.
      #
      # ==== Options
      # +mxmlc_path+:: Path to flex compiler, defaults to 'mxmlc'
      # +swf_path+:: Path to generated swf (required)
      # +target_file+:: Path to target file (.mxml file) (required)
      # +lib_dir+:: Path to lib directory. Will load swc files from here or source directories
      # +src_dirs+:: Path to source directories (required)
      # +config_name+:: Config name, like 'air'
      # +mxmlc_extra_opts+:: Extra options to pass to compiler
      #
      def initialize(options = {})
        assert_required(options, [ :swf_path, :target_file, :src_dirs ])
        
        default_mxmlc_path = options[:config_name].blank? ? "mxmlc" : "mxmlc +configname=#{options[:config_name]}"
        
        with_options(options, { :mxmlc_path => default_mxmlc_path })               
        
        @source_paths = source_paths(@src_dirs, @lib_dir)
        raise ArgumentError, "There aren't any valid source directories to compile" if @source_paths.empty?                
        @library_path = escape(@lib_dir) if @lib_dir and File.directory?(@lib_dir)
      end
            
      # Get the mxmlc compile command
      def compile
        command = []
        command << @mxmlc_path
        command << @mxmlc_extra_opts
        command << "-source-path #{@source_paths.join(" ")}"
        command << "-library-path+=#{@library_path}" unless @library_path.blank?
        command << "-output"
        command << escape(@swf_path)
        command << "-debug=#{@debug}" unless @debug.nil?        
        command << "--"
        command << escape(@target_file)
        process(command)
      end
      
    end
    
  end
  
end