require 'spec_helper'

describe UserMailer do 

  describe '#welcome_email' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'has correct subject' do
      expect(mail.subject).to eq('Welcome to Odinbook')
    end
    it 'has correct receiver' do
      expect(mail.to).to eq([user.email])
    end
    it 'has correct sender' do
      expect(mail.from).to eq(['noreply@odinbook.com'])
    end
    it 'has correct content' do
      expect(mail.body.encoded).to match(user.first_name)
      expect(mail.body.encoded).
        to match("we hope you enjoy using Odinbook")
    end
    it 'delievers email' do
      expect{mail.deliver}.
        to change{ActionMailer::Base.deliveries.count}.by(1)
    end
  end

  describe '#notification_email' do 
    let(:notification) { create(:notification) }
    let(:mail) { UserMailer.notification_email(notification) }

    it 'has correct subject' do
      expect(mail.subject).to eq('New Notification from Odinbook')
    end
    it 'has correct receiver' do
      expect(mail.to).to eq([notification.user.email])
    end
    it 'has correct sender' do
      expect(mail.from).to eq(['noreply@odinbook.com'])
    end
    it 'has correct content' do
      expect(mail.body.encoded).to match(notification.user.first_name)
      expect(mail.body.encoded).to match(notification.message)
    end
    it 'delievers email' do
      expect{mail.deliver}.
      to change{ActionMailer::Base.deliveries.count}.by(1)
    end
  end
end
