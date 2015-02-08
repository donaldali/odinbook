require "spec_helper"

describe User do
  let(:user) { create(:user) }
  subject { user }

  it { should be_valid }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }

  describe "validations" do
    it { should validate_presence_of(:first_name) }

    it { should validate_presence_of(:last_name) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("foo@example.com").for(:email) }
    it { should_not allow_value("foo@example").for(:email) }
    it { should_not allow_value("@example.com").for(:email) }
  end

end
