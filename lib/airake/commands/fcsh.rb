module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # Flex compiler shell.
    #
    # In progress, untested.
    #
    class FCSH < Base
      
      def initialize(options = {})

      end
      
      def generate
        command = []
        command << @swf_path
        process(command)
      end
            
    end
    
  end
  
end