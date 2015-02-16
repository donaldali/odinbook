require 'spec_helper'

describe Notification do
  let(:notification) { create(:notification) }
  subject { notification }

  it { should be_valid }
  it { should respond_to(:message) }
  it { should respond_to(:notification_type) }
  it { should respond_to(:sender) }
  it { should respond_to(:user) }
  it { should respond_to(:user_id) }

  describe "association" do 
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:user_id) }
  end

  describe "#send_notification" do 
    let(:receiver) { notification.user }

    before(:each) do 
      Notification.send_notification(receiver, "request", "Friender")
    end

    it "sends a notification" do 
      expect(receiver.notifications.count).to eq(2)
    end
    it "updates number of new notifications" do 
      expect(receiver.new_notifications).to eq(1)
    end
    it "sends appropriate friend request message" do 
      expect(receiver.notifications.last.message).
        to eq("Friender sent you a Friend Request")
    end
  end

end
