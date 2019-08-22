require 'rails_helper'

RSpec.describe ListItem, type: :model do
  before(:each) do
    @list = List.create(name: 'List 01')
  end

  let! (:params) { {name: 'List Item 01', list_id: @list.id} }
  
  context 'validation tests' do
    it 'ensure name presence' do
      list_item = ListItem.new(params.merge(name: '')).save
      expect(list_item).to eq(false)
    end
    it 'should save successfully' do
      list_item = ListItem.new(params).save
      expect(list_item).to eq(true)
    end
  end

  context 'scope tests' do
    before(:each) do
      ListItem.new(params).save
      ListItem.new(params).save
      ListItem.new(params.merge(deleted: true)).save
      ListItem.new(params.merge(deleted: false)).save
      ListItem.new(params.merge(deleted: false)).save
    end

    it 'should return deleted list items' do
      expect(ListItem.only_deleted.size).to eq(1)
    end
    it 'should return not deleted list items' do
      expect(ListItem.not_deleted.size).to eq(4) # Because by default deleted is false
    end
  end

  context 'method tests' do
    it 'list item should be soft deleted' do
      list_item = ListItem.create(params)
      list_item.delete
      expect(list_item.deleted).to be true
    end
    it 'restore soft deleted list item' do
      list_item = ListItem.create(params)
      list_item.delete
      expect(list_item.deleted).to be true
      list_item.restore
      expect(list_item.deleted).to be false
    end

  end

end
