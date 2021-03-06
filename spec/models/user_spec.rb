require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user)   { build(:user) }
  let(:twisub) { build(:twi_sub) }
  let(:igsub)  { build(:ig_sub) }
  let(:post)   { build(:post) }

  describe "model associations" do
    it "a user has and belongs to a subscription from instagram" do
      user.save
      igsub.save
      igsub.users << user

      expect(igsub.users.first.uid).to eq "789"
      expect(user.subscriptions.first.instagram_id).to eq "215892539"
    end

    it "a user has and belongs to a subscription from twitter" do
      user.save
      twisub.save
      twisub.users << user

      expect(twisub.users.first.uid).to eq "789"
      expect(user.subscriptions.first.twitter_id).to eq "123456"
    end

    it "a user has posts through instagram subscriptions" do
      user.save
      igsub.save
      igsub.users << user
      post.save

      expect(user.posts.count).to eq 1
      expect(user.posts.first).to eq post
    end

    it "a user has posts through twitter subscriptions" do
      user.save
      twisub.save
      twisub.users << user
      post.save

      expect(user.posts.count).to eq 1
      expect(user.posts.first).to eq post
    end
  end

  describe "validations" do

    it "is valid with a provider and uid" do
      expect(user).to be_valid
    end

    it "requires a uid" do
      user = build(:user, uid: nil)

      expect(user).to be_invalid
      expect(user.errors.keys).to include(:uid)
    end

    it "requires a provider" do
      user = build(:user, provider: nil)

      expect(user).to be_invalid
      expect(user.errors.keys).to include(:provider)
    end

    it "uid has to be unique" do
      create(:user)

      expect(user).to be_invalid
      expect(user.errors.keys).to include(:uid)
    end
  end

  describe ".initialize_from_omniauth" do
    context "developer auth" do
      let(:user) { User.find_or_create_user(OmniAuth.config.mock_auth[:developer]) }

      it "creates a valid user" do
        expect(user).to be_valid
      end

      context "when it's invalid" do
        it "returns nil" do
          user = User.find_or_create_user({"uid" => "123", "info" => {}})
          expect(user).to be_nil
        end
      end
    end

    context "instagram auth" do
      let(:user) { User.find_or_create_user(OmniAuth.config.mock_auth[:instagram]) }

      it "creates a valid user" do
        expect(user).to be_valid
      end

      context "when it's invalid" do
        it "returns nil" do
          user = User.find_or_create_user({"uid" => "123", "info" => {}})
          expect(user).to be_nil
        end
      end
    end
  end

  describe "#associate_subscription" do
    it "when called on a user object associates the provided twitter subscription" do
      user.save
      twisub.save
      user.associate_subscription(twisub)

      expect(user.subscriptions.count).to eq 1
      expect(user.subscriptions).to include(twisub)
    end

    it "when called on a user object associates the provided instagram subscription" do
      user.save
      igsub.save
      user.associate_subscription(igsub)

      expect(user.subscriptions.count).to eq 1
      expect(user.subscriptions).to include(igsub)
    end
  end

  describe "#dissociate_subscription" do
    it "dissociates sub from user" do
      user = create(:user)
      igsub = create(:ig_sub)
      twisub = create(:twi_sub)

      user.subscriptions << [igsub, twisub]

      user.dissociate_subscription(igsub)

      expect(user.subscriptions.count).to eq 1
    end
  end

  describe "#already subscribed" do
    it "returns true if user is already subscribed to the twitter user" do
      user.save
      twisub.save
      user.subscriptions << twisub

      expect(user.already_subscribed?(twisub.twitter_id)).to eq true
    end

    it "returns true if user is already subscribed to the instagram user" do
      user.save
      igsub.save
      user.subscriptions << igsub

      expect(user.already_subscribed?(igsub.instagram_id)).to eq true
    end

    it "returns nil if user is not subscribed to the twitter user" do
      user.save
      twisub.save

      expect(user.already_subscribed?(twisub.twitter_id)).to eq nil
    end

    it "returns nil if user is not subscribed to the instagram user" do
      user.save
      igsub.save

      expect(user.already_subscribed?(igsub.instagram_id)).to eq nil
    end
  end

  describe "#instagram_subscriptions" do
    it "return a collection of only instagram subscriptions for a user" do
      user.save
      igsub.save
      twisub.save
      igsubtwo = create(:ig_sub, instagram_id: "9876543")
      user.subscriptions << [igsub, igsubtwo, twisub]

      expect(user.instagram_subscriptions.count).to eq 2
    end
  end
end
