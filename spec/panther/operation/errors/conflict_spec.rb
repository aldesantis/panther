# frozen_string_literal: true
RSpec.describe Panther::Operation::Errors::Conflict do
  subject { described_class.new }

  it 'has a status code' do
    expect(subject.status).to eq(:conflict)
  end

  it 'has a type' do
    expect(subject.type).to eq(:conflict)
  end
end
