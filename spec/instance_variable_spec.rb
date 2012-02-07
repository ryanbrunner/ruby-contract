require 'spec_helper'

class ExampleAddClass
  extend Contract::DesignContracts

  attr_accessor :allow_add

  define_contract_method :add, :num, :num2 do 
    requires { allow_add }
    implementation do
      num + num2
    end
  end
  
end

describe ExampleAddClass do
  
  describe "#can_add?" do
    specify { example_class.should respond_to :can_add? }
    let (:example_class) { ExampleAddClass.new }
    subject { example_class.can_add?(1,1) }

    context "Don't allow add" do
      before { example_class.allow_add = false }
      it { should be_false }
    end

    context "Allow add" do
      before { example_class.allow_add = true }
      it { should be_true }
    end
  end
end