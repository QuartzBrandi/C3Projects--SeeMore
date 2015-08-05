require 'rails_helper'

RSpec.describe IgSubscription, type: :model do

  describe "model validations" do
    let(:ig_subscription) {
      IgSubscription.new(instagram_id: "@beast")
      }

    it "requires an instagram id" do

      expect(ig_subscription).to be_valid
    end

    it "won't create a subscription without an id" do
      invalid_sub = IgSubscription.new

      expect(invalid_sub).to be_invalid
      expect(invalid_sub.errors.keys).to include(:instagram_id)
    end

    it "wont create a duplicate subscription" do
      ig_subscription.save
      dup_sub = IgSubscription.new(instagram_id: "@beast")

      expect(dup_sub).to be_invalid
      expect(dup_sub.errors.keys).to include(:instagram_id)
    end
  end

  describe "model associations" do
    it "an IG subscription has and belongs to a user" do
      user = User.create(name: "user1", provider: "developer", uid: "uid1")
      igsub = IgSubscription.create(instagram_id: "@beast")
      user.ig_subscriptions << igsub

      expect(user.ig_subscriptions.first.instagram_id).to eq "@beast"
      expect(igsub.users.first.name).to eq "user1"
    end
  end

end