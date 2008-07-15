class ClassGenerator < RubiGen::Base
  
  attr_reader :name, :package, :class_name, :src_dir
  
  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
        
    @src_dir = args.shift unless args.empty?    
    @src_dir ||= "src"
    
    # Split com.foo.Bar into package ["com", "foo" ] and class_name "Bar"
    if @name.rindex(".")
      @package = @name[0...@name.rindex(".")] 
      @class_name = @name[@name.rindex(".")+1..-1]
    else
      @package = ""
      @class_name = @name
    end
    
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists      
      
      dir = src_dir
      unless package.blank?
        dir = File.join(src_dir, package.split("."))
        m.directory dir 
      end
      
      m.template "Class.as", File.join(dir, class_name + ".as")
      
    end
  end

  protected
    def banner
      ""
    end

    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      # opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end
    
    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end
end