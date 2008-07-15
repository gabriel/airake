module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # ADT (Adobe Developer Tool)
    #
    # http://livedocs.adobe.com/labs/air/1/devappsflex/help.html?content=CommandLineTools_5.html
    class Adt < Base
      
      attr_reader :adt_path, :cert, :adt_extra_opts, :assets, :air_path, :appxml_path, :swf_path, :base_dir
      
      # Create ADT command.
      #
      # ==== Options
      # +adt_path+:: Path to adt, defaults to 'adt'
      # +base_dir+:: Root directory for project (required). Directories like src, lib and bin should be visible from here.
      # +air_path+:: Path to generated AIR file (required)
      # +appxml_path+:: Path to application xml descriptor (required)
      # +swf_path+:: Path to compiled SWF file (required)
      # +assets+:: Path to any assets. Should a string with asset files and directories separated by spaces: 'assets/icons/foo.png assets/images'
      # +cert+:: Path to certificate     
      # +adt_extra_opts+:: Extra options for command line
      #
      def initialize(options = {})        
        with_options(options, { :adt_path => "adt" })
      end
            
      # Package
      def package
        assert_not_blank(:air_path, :appxml_path, :swf_path)
        
        command = []
        command << @adt_path        
        command << "-package"        
        command << @adt_extra_opts
        
        unless @cert.blank?
          command << "-keystore #{@cert}" 
          command << "-storetype pkcs12"
        end
        command << escape(relative_path(@air_path, @base_dir))
        command << escape(relative_path(@appxml_path, @base_dir))
        command << escape(relative_path(@swf_path, @base_dir))
        command << @assets unless @assets.nil?
        process(command)
      end
      
      # ADT certificate command
      #
      # * cn: Common name
      # * pfx_file: Output certificate path
      # * key_type: 1024-RSA, 2048-RSA
      # * password: Password
      # * optionals:
      # * * org: Organization. 'Adobe'
      # * * org_unit: Orginizational unit. 'AIR Team'
      # * * country: Country. 'USA'
      #
      # Example result: 
      #   adt -certificate -cn ADigitalID 1024-RSA SigningCert.pfx 39#wnetx3tl
      #
      def certificate(common_name, pfx_file, key_type, password, optionals = {})
        command = []
        command << @adt_path
        command << "-certificate"
        command << "-cn #{common_name}"
        command << "-ou #{optionals[:org_unit]}" if !optionals[:org_unit].blank?
        command << "-o #{optionals[:org]}" if !optionals[:org].blank?
        command << "-c #{optionals[:country]}" if !optionals[:country].blank?
        command << key_type
        command << escape(pfx_file)
        command << password
        process(command)
      end      
      
    end
    
  end
  
end