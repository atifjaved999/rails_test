require 'rails_helper'

RSpec.describe List, type: :model do
  context 'validation tests' do
    it 'ensure name presence' do
      list = List.new(name: '').save
      expect(list).to eq(false)
    end
    it 'should save successfully' do
      list = List.new(name: 'List 01').save
      expect(list).to eq(true)
    end
  end

  context 'scope tests' do
    let (:params) { {name: 'List 01'} }
    before(:each) do
      List.new(params).save
      List.new(params).save
      List.new(params.merge(deleted: true)).save
      List.new(params.merge(deleted: false)).save
      List.new(params.merge(deleted: false)).save
    end

    it 'should return deleted list' do
      expect(List.only_deleted.size).to eq(1)
    end
    it 'should return not deleted list' do
      expect(List.not_deleted.size).to eq(4) # Because by default deleted is false
    end
  end

  context 'method tests' do
    it 'list should be soft deleted' do
      list = List.create(name: 'List 01')
      list.delete
      expect(list.deleted).to be true
    end
    it 'restore soft deleted list' do
      list = List.create(name: 'List 01')
      list.delete
      expect(list.deleted).to be true
      list.restore
      expect(list.deleted).to be false
    end

  end

end
