
  module Contract::DesignContracts
    def define_contract_method (method, *args, &block)
      config = init_config(method)
      puts config.to_yaml
      config.instance_eval &block

      
      define_method method do |*inst_args|
        config.setup_args(args, inst_args, self)
        raise "Pre-condition not satisfied" unless config.preconditions.all? { |pre| config.instance_eval &pre }
        
        config.instance_eval &config.execute if config.execute
        self.send(method)
      end

      
      define_method "can_#{method}?" do |*inst_args|
        config.setup_args(args, inst_args, self)
        config.preconditions.all? { |pre| config.instance_eval &pre } && send(method, *inst_args)
        self.send("super_can_#{method}?")
      end
    end

  private
    
    def init_config(method_name)
      puts "here"
      @methods ||= {}
      return @methods[method_name] || @methods[method_name] = Contract::Config.new
    end
  end

  class Contract::Config
    attr_reader :preconditions
    attr_reader :execute
    
    def initialize
      @preconditions = []
      @execute = nil
    end

    def method_missing(method, *args)
      @caller.send(method, *args)
    end

    def metaclass
      class << self; self; end
    end

    def requires(&block)
      @preconditions << block
    end

    def implementation(&block)
      @execute = block
    end

    def setup_args(args, inst, caller)
      @caller = caller

      args.each_with_index do |a, i|
        metaclass.send(:define_method, a) { inst[i] }
      end
    end
  end