# frozen_string_literal: true
RSpec.describe Panther::Operation::Errors::PaymentRequired do
  subject { described_class.new }

  it 'has a status code' do
    expect(subject.status).to eq(:payment_required)
  end

  it 'has a type' do
    expect(subject.type).to eq(:payment_required)
  end
end
