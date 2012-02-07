class ExampleClass
  define_method :foo do
    'bar'
  end

  def define_method(name, &block)

  end
end

ExampleClass.new.foo   # bar
