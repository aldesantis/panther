# frozen_string_literal: true
RSpec.describe Panther::Operation::Errors::TooManyRequests do
  subject { described_class.new }

  it 'has a status code' do
    expect(subject.status).to eq(:too_many_requests)
  end

  it 'has a type' do
    expect(subject.type).to eq(:too_many_requests)
  end
end
