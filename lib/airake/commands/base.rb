require 'pathname'

module Airake #:nodoc:
  
  module Commands #:nodoc:
    
    # Base command 
    class Base 
      
      # Process command options array
      def process(command)
        command.compact.join(" ")
      end
      
      # Escape any spacing
      def escape(command)
        if windows?
          if command =~ /\S+\s+\S+/ then 
            command = "\"#{command}\""
          end
        else 
          command = command.to_s.gsub(" ", "\\ ")
        end
        command
      end
      
      # Get relative path
      def relative_path(path, from)
        Pathname.new(path).relative_path_from(Pathname.new(from))
      end      
      
      def windows?
        RUBY_PLATFORM =~ /win32/
      end
      
      def with_options(options, defaults = {}) 
        options.each do |key, value|
          raise "Invalid option: '#{key}' for command: #{self.class}" unless respond_to?(key.to_sym)
          instance_variable_set("@#{key}", value)          
        end
        
        defaults.each do |key, value|
          existing = instance_variable_get("@#{key}")
          instance_variable_set("@#{key}", value) unless existing
        end
      end
      
      def assert_required(options, keys)        
        keys.each do |key|
          raise ArgumentError, "Missing option: #{key}" unless options.include?(key)
        end
      end
      
      def assert_not_blank(*instance_vars)
        instance_vars.each do |var|
          instance = instance_variable_get("@#{var}")
          raise ArgumentError, "#{var} can't be blank" if instance.blank?
        end
      end
      
      def library_paths(lib_dir)
        if lib_dir and File.directory?(lib_dir) 
          Dir["#{lib_dir}/*"].collect { |f| escape(f) if File.directory?(f) }.compact 
        end
      end
      
      # Returns an array of source paths from src_dirs and lib_dir
      def source_paths(src_dirs = [], lib_dir = nil)
        source_paths = []
        
        # List of directories in lib/ for source paths
        if lib_dir and File.directory?(lib_dir) 
          source_paths += Dir["#{lib_dir}/*"].collect { |f| escape(f) if File.directory?(f) }.compact 
        end
        
        src_dirs.each do |src_dir|
          if File.directory?(src_dir)
            source_paths << escape(src_dir) 
          else
            raise "Source directory: #{src_dir} is not a directory or does not exist"
          end
        end
        source_paths
      end
      
      # Find classes list from packages, raises error if result is empty
      def include_classes(source_path, include_packages)
        classes = []
        paths = []
        include_packages.each do |include_package|
          path = File.join(source_path, include_package.gsub(".", "/")) + "/**/*.as"
          paths << path
          Dir[path].each do |file|
            classes << include_package + "." + File.basename(file).gsub(".as", "")
          end
        end
        raise "No classes found at:\n\t#{paths.join("\n\t")}" if classes.empty?
        classes
      end
      
    end
    
  end
  
end