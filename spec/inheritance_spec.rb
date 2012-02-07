require 'spec_helper'

class OpenExample
  extend Contract::DesignContracts

  attr_accessor :is_deleted

  define_contract_method :delete_stuff do 
    implementation do
      is_deleted = true
    end
  end
end

class SecuredExample < OpenExample
  attr_accessor :password_provided

  define_contract_method :delete_stuff do
    requires { password_provided }
  end
end

describe OpenExample do
  describe "#can_delete_stuff?" do
    specify { example_class.should respond_to :can_delete_stuff? }
    let (:example_class) { OpenExample.new }
    subject { example_class.can_delete_stuff? }

    it { should be_true }
  end
end

describe SecuredExample do
  describe "#can_delete_stuff?" do
    let (:example_class) { SecuredExample.new }

    specify { example_class.should respond_to :can_delete_stuff? }
    subject { example_class.can_delete_stuff? }

    context "without password provided" do
      before { example_class.password_provided = false }
      it { should be_false }
    end
    context "with password provided" do
      before { example_class.password_provided = true }
      it { should be_true }
      # check that we can actually call the method too (i.e. implementation wasn't wiped out)
      specify {
        example_class.delete_stuff
        example_class.is_deleted.should == true
      }
    end
  end
end