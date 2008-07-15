module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # ASDOC
    class Asdoc < Base
      
      attr_reader :asdoc_path, :asdoc_extra_opts, :src_dirs, :lib_dir, :output_dir
      
      # Create ASDOC command.
      #
      # ==== Options
      # +asdoc_path+:: Path to asdoc, defaults to 'asdoc'
      # +src_dirs+:: Paths to source (array), defaults to [ 'src' ]
      # +lib_dir+:: Path to lib directory.
      # +output_dir+:: Path to output directory, defaults to "doc/asdoc"
      # +asdoc_extra_opts+:: Extra options for command line
      #
      def initialize(options = {})
        with_options(options, { :asdoc_path => "asdoc", :output_dir => "doc/asdoc" })               
        
        @source_paths = source_paths(@src_dirs, @lib_dir)
        raise ArgumentError, "There aren't any valid source directories to compile" if @source_paths.empty?
        
        @library_paths = []
        if @lib_dir and File.directory?(@lib_dir)
          @library_paths << escape(@lib_dir) 
        end
        @library_paths << "#{frameworks_dir}/libs"
        @library_paths << "#{frameworks_dir}/libs/air"
        @library_paths << "#{frameworks_dir}/locale/en_US"
      end
      
      # This only works on bash
      def frameworks_dir
        "$(dirname `which asdoc`)/../frameworks"
      end
            
      # Get the amxmlc compile command
      def generate
        command = []
        command << @asdoc_path
        command << @asdoc_extra_opts
        command << "-source-path #{@source_paths.join(" ")}"
        
        @library_paths.each do |library_path|
          command << "-library-path #{library_path}"
        end
        command << "-doc-sources #{@source_paths.join(" ")}"
        command << "-output #{@output_dir}"              
        process(command)
      end
            
    end
    
  end
  
end