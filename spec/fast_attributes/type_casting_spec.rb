require 'spec_helper'

describe FastAttributes::TypeCasting do
  let(:type_casting) { described_class.new }
  let(:value) { 'test' }

  context 'string' do
    before(:each) do
      type_casting.store(String, value)
    end

    it 'must store class and value' do
      expect(type_casting[String]).to eq value
      expect(type_casting[:string]).to eq value
    end

    it 'must check if any key exists' do
      expect(type_casting.key?(String)).to be true
      expect(type_casting.key?(:string)).to be true
      expect(type_casting.key?(:collection_member)).to be false
    end

    it 'must delete all keys by klass' do
      type_casting.delete(String)

      expect(type_casting.key?(String)).to be false
      expect(type_casting.key?(:string)).to be false
    end
  end

  context 'array' do
    before(:each) do
      type_casting.store(Array[Integer], value)
    end

    it 'must store with special key and value' do
      expect(type_casting[:collection_member]).to eq value
    end
  end

  it 'must underscore klass' do
    expect(type_casting.send(:underscore, String)).to eq :string
    expect(type_casting.send(:underscore, 'String')).to eq :string
    expect(type_casting.send(:underscore, :string)).to eq :string

    expect(type_casting.send(:underscore, 'UserForm')).to eq :user_form
  end
end
