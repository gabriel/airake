module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # ACOMPC (Air component compiler)
    #
    # http://livedocs.adobe.com/labs/flex3/html/help.html?content=CommandLineTools_3.html
    class Acompc < Base
      
      attr_reader :acompc_path, :acompc_extra_opts, :source_path, :include_packages, :output_path
      
      # Create ACOMPC command.
      # 
      # ==== Options
      # +acompc_path+:: Path to acompc, defaults to 'acompc'
      # +source_path+:: Path to source, defaults to 'src'
      # +output_path+:: Path to output (required)
      # +include_packages+:: Array of package names to include (required). Example, com.airake.utils will include all classes from Dir["com/airake/utils/**/*.as"]      
      # +acompc_extra_opts+:: Extra options for command line
      #
      def initialize(options = {})
        assert_required(options, [ :output_path, :include_packages ])
        with_options(options, { :acompc_path => "acompc", :source_path => "src" })                        
        @include_classes = include_classes(@source_path, @include_packages)
      end
      
      # Get the acompc compile command
      def compile
        command = []
        command << @acompc_path
        command << @acompc_extra_opts
        command << "-source-path"
        command << @source_path
        command << "-include-classes"
        command << @include_classes.join(" ")
        command << "-output"
        command << @output_path        
        process(command)
      end
            
    end
    
  end
  
end