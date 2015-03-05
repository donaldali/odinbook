require 'spec_helper'

describe Notification do
  let(:notification) { create(:notification) }
  let(:receiver)     { notification.user }
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

  describe "#make_message" do
    it "gives appropriate message for friend request" do
      message = Notification.make_message("request", "Friender")
      expect(message).to eq("Friender sent you a Friend Request")
    end
    it "gives default message for unknown message type" do
      message = Notification.make_message("unknown", "Friender")
      expect(message).to eq("Default Notification")
    end
  end

  describe ".send_notification_email" do 

    context "for users with email notification" do
      it "delievers email" do
        expect{notification.send_notification_email}.
          to change{ActionMailer::Base.deliveries.count}.by(1)
      end
    end
    
    context "for users without email notification" do
      it "doesn't delievers email" do
        receiver.profile.email_notification = false
        expect{notification.send_notification_email}.
          not_to change{ActionMailer::Base.deliveries.count}
      end
    end
  end
end
