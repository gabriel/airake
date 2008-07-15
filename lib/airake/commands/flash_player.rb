module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # Flash Player (standalone)
    #
    # In progress, untested.
    #
    class FlashPlayer < Base
      
      attr_reader :swf_path
      
      # Create Flash Player command.
      #
      # ==== Options
      # +flash_player+:: Path to flash player, defaults to '/Applications/Flash Player.app/Contents/MacOS/Flash Player'
      # +swf_path+:: Path to swf
      #
      def initialize(options = {})
        with_options(options, { :flash_player => "/Applications/Flash Player.app/Contents/MacOS/Flash Player" })               
      end
      
      # The flash player command
      def generate
        command = []
        command << @swf_path
        process(command)
      end
            
    end
    
  end
  
end