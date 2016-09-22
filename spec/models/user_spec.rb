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
    it { is_expected.to have_many(:units).through(:memberships) }

    it 'has distinct units' do
      user = create(:user)
      unit = create(:unit)
      create(:membership, user: user, unit: unit)
      create(:membership, user: user, unit: unit, level: 'DataEntry')

      expect(user.units.count).to eq 1
    end
  end

  describe '#to_s' do
    let(:user) { build(:user) }

    it 'returns the user email' do
      expect(user.to_s).to eq user.email
    end
  end

  describe '#groups' do
    let(:user) { create(:user) }
    let(:unit1) { create(:unit, name: 'Unit1', key: 'unit1') }
    let(:unit2) { create(:unit, name: 'Unit2', key: 'unit2') }

    it 'returns all unit keys' do
      create(:membership, user: user, unit: unit1)
      create(:membership, user: user, unit: unit2)

      expect(user.groups).to eq ['unit1', 'unit2']
    end

    context 'user is an admin' do
      let(:admin_user) { create(:admin_user) }

      it 'includes the Administrators group' do
        create(:membership, user: admin_user, unit: unit1)
        create(:membership, user: admin_user, unit: unit2)

        expect(admin_user.groups).to eq ['unit1', 'unit2', 'Administrators']
      end
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

  describe '#in_unit?' do
    let(:user) { create(:user) }

    it 'returns true when the user is a member of at least one unit' do
      create(:membership, user: user)
      expect(user.in_unit?).to be true
    end

    it 'returns false when the user is not a member of a unit' do
      expect(user.in_unit?).to be false
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
