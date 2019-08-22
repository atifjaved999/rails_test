require 'rails_helper'

RSpec.describe ListItemsController, type: :controller do
  let(:valid_nested_attributes) {
    {name: 'List 01', list_items_attributes: {id: '', name: 'List Item 01'}} 
  }

  before(:each) do
    @list = List.create!(valid_nested_attributes)
    @list_item = @list.list_items[0]
  end

  context "DELETE #destroy" do
    subject { delete :destroy, params: {id: @list_item.to_param}, xhr: true, format: :js }

    it "destroys the requested list Item" do
      expect { subject }.to change(ListItem, :count).by(-1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
  end

  context "POST #soft_delete" do
    subject { post :soft_delete, params: {id: @list_item.to_param}, xhr: true, format: :js }

    it "soft delete the requested list Item" do
      expect { subject }.to change(ListItem, :count).by(-1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
  end

  context "POST #restore" do
    before do
      @list_item.delete
    end
    subject { post :restore, params: {id: @list_item.to_param}, xhr: true, format: :js }

    it "check restore the requested list Item" do
      expect { subject }.to change(ListItem, :count).by(1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
  end
end
