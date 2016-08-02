require 'rails_helper'

RSpec.describe Identity, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validation" do
    subject { build(:identity) }

    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe '.from_omniauth' do
    let(:auth) { build(:auth_hash) }

    context 'when a there is a matching identity' do
      it 'returns the matching identity' do
        identity = create(:identity)
        expect(described_class.from_omniauth(auth)).to eq identity
      end
    end

    context 'when there is no matching identity' do
      it 'returns a new identity' do
        expect(described_class.from_omniauth(auth)).to be_an_instance_of described_class
      end

      context 'when there is a matching user' do
        it 'uses the correct user model' do
          user = create(:user)

          identity = described_class.from_omniauth(auth)

          expect(identity.user).to eq user
        end
      end

      context 'when there is no matching user model' do
        it 'creates a new user' do
          identity = described_class.from_omniauth(auth)
          expect(identity.user).to be_an_instance_of User
        end
      end
    end
  end
end
