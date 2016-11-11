RSpec.describe Panther::Operation::Errors::Forbidden do
  subject { described_class.new }

  it 'has a status code' do
    expect(subject.status).to eq(:forbidden)
  end

  it 'has a type' do
    expect(subject.type).to eq(:forbidden)
  end
end
