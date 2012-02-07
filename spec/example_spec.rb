require 'spec_helper'

class ExampleClass
  extend Contract::DesignContracts

  define_contract_method :divide, :num, :denominator do 
    requires { denominator > 0 }
    implementation do
      num / denominator
    end
  end
  
end

describe ExampleClass do
  subject { ExampleClass }
  it { should respond_to :define_contract_method }

  describe "#divide" do
    specify { ExampleClass.new.should respond_to :divide }

    subject { ExampleClass.new.divide(numerator, denominator) }
    let(:numerator) { 2 }

    context "Denominator = 0" do
      let(:denominator) { 0 }

      specify { expect { subject }.to raise_error }
    end

    context "Denominator = -1" do
      let(:denominator) { -1 }

      specify { expect { subject }.to raise_error }
    end

    context "Denominator = 1" do
      let(:denominator) { 1 }
      it { should == 2 }
    end
  end


  describe "#can_divide?" do
    specify { ExampleClass.new.should respond_to :can_divide? }

    subject { ExampleClass.new.can_divide?(numerator, denominator) }
    let(:numerator) { 2 }

    context "Denominator = 0" do
      let(:denominator) { 0 }
      it { should be_false }
    end

    context "Denominator = 1" do
      let(:denominator) { 1 }
      it { should be_true }
    end
  end
end