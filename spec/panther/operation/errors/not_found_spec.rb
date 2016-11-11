RSpec.describe Panther::Operation::Errors::NotFound do
  subject { described_class.new }

  it 'has a status code' do
    expect(subject.status).to eq(:not_found)
  end

  it 'has a type' do
    expect(subject.type).to eq(:not_found)
  end
end
