module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # ADL (Adobe Debug Lancher)
    #
    # http://livedocs.adobe.com/labs/air/1/devappsflex/help.html?content=CommandLineTools_4.html#1031914
    class Adl < Base
      
      attr_reader :adl_path, :adl_extra_opts, :appxml_path, :base_dir
      
      # Create ADL command.
      #
      # ==== Options
      # +adl_path+:: Path to adl, defaults to 'adl'
      # +appxml_path+:: Path to application descriptor xml (required)
      # +base_dir+:: Path to base project directory (required)
      # +adl_extra_opts+:: Extra options for command line
      #
      def initialize(options = {})
        assert_required(options, [ :appxml_path, :base_dir ])
        with_options(options, { :adl_path => "adl" })
        
        # For full path
        @appxml_path = File.expand_path(@appxml_path)
      end
      
      # Get the ADL launch command
      def launch
        command = []
        command << @adl_path
        command << @adl_extra_opts
        command << escape(@appxml_path)
        command << escape(@base_dir)
        process(command)
      end      
      
    end
    
  end
  
end