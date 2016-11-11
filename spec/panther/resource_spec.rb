RSpec.describe Panther::Resource do
  before(:all) do
    module API
      module V1
        class User < Panther::Resource
          module Operation; end
          module Representer; end
          module Contract; end
        end
      end
    end
  end

  subject { API::V1::User }

  describe '.policy_klass' do
    it 'returns the policy class' do
      expect(subject.policy_klass).to eq('API::V1::User::Policy')
    end
  end

  describe '.policy?' do
    it 'returns whether the policy class is defined' do
      expect {
        API::V1::User::Policy = Class.new
      }.to change { subject.policy? }.from(false).to(true)
    end
  end

  describe '.operation_klass' do
    it 'returns the class of the given operation' do
      expect(subject.operation_klass(:create)).to eq('API::V1::User::Operation::Create')
    end
  end

  describe '.operation?' do
    it 'returns whether the operation class is defined' do
      expect {
        API::V1::User::Operation::Create = Class.new
      }.to change { subject.operation?(:create) }.from(false).to(true)
    end
  end

  describe '.representer_klass' do
    it 'returns the class of the given representer' do
      expect(subject.representer_klass(:resource)).to eq('API::V1::User::Representer::Resource')
    end
  end

  describe '.representer?' do
    it 'returns whether the representer class is defined' do
      expect {
        API::V1::User::Representer::Create = Class.new
      }.to change { subject.representer?(:create) }.from(false).to(true)
    end
  end

  describe '.contract_klass' do
    it 'returns the class of the given contract' do
      expect(subject.contract_klass(:create)).to eq('API::V1::User::Contract::Create')
    end
  end

  describe '.contract?' do
    it 'returns whether the contract class is defined' do
      expect {
        API::V1::User::Contract::Create = Class.new
      }.to change { subject.contract?(:create) }.from(false).to(true)
    end
  end
end
