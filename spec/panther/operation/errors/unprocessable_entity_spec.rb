# frozen_string_literal: true
RSpec.describe Panther::Operation::Errors::UnprocessableEntity do
  subject { described_class.new }

  it 'has a status code' do
    expect(subject.status).to eq(:unprocessable_entity)
  end

  it 'has a type' do
    expect(subject.type).to eq(:unprocessable_entity)
  end
end
