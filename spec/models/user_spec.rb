require 'rails_helper'

RSpec.describe User, type: :model do
  describe "modules" do
    it { is_expected.to include_module(Hydra::User) }
    it { is_expected.to include_module(CurationConcerns::User) }
    it { is_expected.to include_module(Sufia::User) }
    it { is_expected.to include_module(Sufia::UserUsageStats) }
  end

  describe "associations" do
    it { is_expected.to have_many(:identities).dependent(:destroy) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:units) }
  end

  describe '#to_s' do
    let(:user) { build(:user) }

    it 'returns the user email' do
      expect(user.to_s).to eq user.email
    end
  end

  describe '#admin?' do
    it 'returns true when the user is an admin' do
      user = build(:admin_user)
      expect(user.admin?).to be true
    end

    it 'returns false when the user is not an admin' do
      user = build(:user)
      expect(user.admin?).to be false
    end
  end

  describe '.from_omniauth' do
    let(:auth) { build(:auth_hash) }

    context 'when a there is a matching user' do
      it 'returns the matching user' do
        user = create(:user)
        expect(described_class.from_omniauth(auth)).to eq user
      end
    end

    context 'when there is no matching user' do
      it 'returns a new user based on omniauth attributes' do
        user = described_class.from_omniauth(auth)

        expect(user).to be_an_instance_of described_class
        expect(user.display_name).to eq auth.info.name
        expect(user.email).to eq auth.info.email
      end
    end
  end
end
