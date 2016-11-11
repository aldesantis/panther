RSpec.describe Panther::Operation::Base do
  before(:all) do
    module API
      module V1
        class Post < Panther::Resource
          module Operation
            class Create < Panther::Operation::Base
              def call; end
            end
          end
        end
      end
    end
  end

  subject { API::V1::Post::Operation::Create.new(params: params) }

  let(:params) { { current_user: OpenStruct.new }}

  describe '.operation_name' do
    it 'returns the name of the operation' do
      expect(subject.class.operation_name).to eq('create')
    end
  end

  describe '#operation_name' do
    it 'returns the name of the operation' do
      expect(subject.operation_name).to eq('create')
    end
  end

  describe '#params' do
    it 'returns the params the operation was executed with' do
      expect(subject.params).to eq(params)
    end
  end

  describe '#current_user' do
    it 'returns the current_user param' do
      expect(subject.current_user).to eq(params[:current_user])
    end
  end

  describe '#authorize' do
    let(:resource) { OpenStruct.new }

    it 'authorizes the resource' do
      expect(Panther::Authorizer).to receive(:authorize!)
        .with(
          resource: resource,
          user: params[:current_user],
          operation: API::V1::Post::Operation::Create
        )
        .once

      subject.authorize resource
    end
  end

  describe '#validate' do
    let(:resource) { OpenStruct.new }

    it 'validates the resource' do
      expect(Panther::Validator).to receive(:validate!)
        .with(resource: resource)
        .once

      subject.validate resource
    end
  end

  describe '#authorize_and_validate' do
    before do
      allow(Panther::Authorizer).to receive(:authorize!)
      allow(Panther::Validator).to receive(:validate!)
    end

    let(:resource) { OpenStruct.new }

    it 'authorizes the resource' do
      expect(Panther::Authorizer).to receive(:authorize!)
        .with(
          resource: resource,
          user: params[:current_user],
          operation: API::V1::Post::Operation::Create
        )
        .once

      subject.authorize resource
    end

    it 'validates the resource' do
      expect(Panther::Validator).to receive(:validate!)
        .with(resource: resource)
        .once

      subject.validate resource
    end
  end

  describe '#respond_with' do
    let(:resource) { OpenStruct.new }

    let(:response) { -> { subject.respond_with status: :ok, resource: resource } }

    it 'sets the status' do
      expect(response).to change(subject.context, :status).to(:ok)
    end

    it 'sets the resource' do
      expect(response).to change(subject.context, :resource).to(resource)
    end
  end

  describe '#head' do
    it 'sets the status' do
      expect { subject.head :ok }.to change(subject.context, :status).to(:ok)
    end
  end

  it 'ensures a status code is set'
  it 'converts ActiveRecord::RecordNotFound into Panther::Operation::Errors::NotFound'
  it 'handles Panther errors'
end
