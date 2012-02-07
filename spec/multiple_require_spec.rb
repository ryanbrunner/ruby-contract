require 'spec_helper'

class ExampleAddPositivesClass
  extend Contract::DesignContracts

  define_contract_method :add_positives, :num, :num2 do 
    requires { num > 0 }
    requires { num2 > 0 }

    implementation do
      num + num2
    end
  end
  
end

describe ExampleAddPositivesClass do
  
  describe "#can_add?" do
    specify { example_class.should respond_to :can_add_positives? }
    let (:example_class) { ExampleAddPositivesClass.new }
    let(:num1) { 1 }
    let(:num2) { 1 }
    subject { example_class.can_add_positives?(num1,num2) }

    context "Num1 is negative" do
      let(:num1) { -1 }
      it { should be_false }
    end

    context "Num2 is negative" do
      let(:num2) { -1 }
      it { should be_false }
    end

    context "Both are negative" do
      let(:num1) { -1 }
      let(:num2) { -1 }
      it { should be_false }
    end

    context "Both are positive" do
      it { should be_true }
    end
  end
end