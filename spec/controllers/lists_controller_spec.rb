require 'rails_helper'

RSpec.describe ListsController, type: :controller do

  let(:valid_nested_attributes) {
    {name: 'List 01', list_items_attributes: {id: '', name: 'List Item 01'}} 
  }

  let(:invalid_nested_attributes) {
    {name: '', list_items_attributes: {id: '', name: ''}} 
  }

  before(:each) do |test|
    unless test.metadata[:skip_before]
      @list = List.create! valid_nested_attributes
    end
  end

  context "GET #index", skip_before: true do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  context "GET #new", skip_before: true do
    it "returns a success response" do
      get :new, xhr: true, format: :js
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
  end

  context "GET #edit" do
    it "returns a success response" do
      get :edit, params: {id: @list.to_param}, xhr: true, format: :js
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
  end
 
  describe "POST #create", skip_before: true do
    context "with valid params" do
      subject {post :create, params: {list: valid_nested_attributes}, xhr: true, format: :js}

      it "creates a new List" do
        expect { subject }.to change(List, :count).by(1)
      end
      it "creates a new List Item" do
        expect { subject }.to change(ListItem, :count).by(1)
      end
      it "renders js to display lists" do
        subject
        expect(response.content_type).to eq('text/javascript')
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      subject {post :create, params: {list: invalid_nested_attributes}, xhr: true, format: :js}

      it "Fails to create a new List" do
        expect { subject }.to change(List, :count).by(0)
      end
      it "Fails to create a new List Item" do
        expect { subject }.to change(ListItem, :count).by(0)
      end
      it "renders js to display lists" do
        subject
        expect(response.content_type).to eq('text/javascript')
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let (:new_valid_attributes) {
        {name: 'List 01 -- updated', list_items_attributes: {id: @list.list_items[0].to_param, name: 'List Item 01 -- updated'}} 
      }

      subject {put :update, params: {id: @list.to_param, list: new_valid_attributes}, xhr: true, format: :js}

      it "updates the requested list" do
        subject
        @list.reload
      end
      it "udpates a new List" do
        subject
        @list.reload
        expect(@list.name).to eq new_valid_attributes[:name]
      end
      it "udpates a new List Item" do
        subject
        @list.reload
        expect(@list.list_items[0].name).to eq new_valid_attributes[:list_items_attributes][:name]
      end
      it "renders js to display lists" do
        subject
        expect(response.content_type).to eq('text/javascript')
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      
      let (:new_invalid_attributes) {
        {name: '', list_items_attributes: {id: @list.list_items[0].to_param, name: ''}} 
      }

      subject {put :update, params: {id: @list.to_param, list: new_invalid_attributes}, xhr: true, format: :js}

      it "Fails to update the requested list" do
        subject
        @list.reload
        expect(@list.name).not_to be new_invalid_attributes[:name]
      end
      it "Fails to udpate the List Item" do
        subject
        @list.reload
        expect(@list.list_items[0].name).not_to be new_invalid_attributes[:list_items_attributes][:name]
      end
      it "renders js to display lists" do
        subject
        expect(response.content_type).to eq('text/javascript')
        expect(response).to be_successful
      end
    end
  end

  context "DELETE #destroy" do
    subject { delete :destroy, params: {id: @list.to_param}, xhr: true, format: :js }
    
    it "destroys the requested list" do
      expect { subject }.to change(List, :count).by(-1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
    it "destroys the requested list Item" do
      expect { subject }.to change(ListItem, :count).by(-1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end

  end

  context "POST #soft_delete" do
    subject { post :soft_delete, params: {id: @list.to_param}, xhr: true, format: :js }
    
    it "soft delete the requested list" do
      expect { subject }.to change(List, :count).by(-1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
    it "soft delete the requested list Item" do
      expect { subject }.to change(ListItem, :count).by(-1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end

  end

  context "POST #restore" do
    before(:each) do
      @list.delete
    end

    subject { post :restore, params: {id: @list.to_param}, xhr: true, format: :js }
    
    it "check restore the requested list" do
      expect { subject }.to change(List, :count).by(1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end
    it "check restore the requested list Item" do
      expect { subject }.to change(ListItem, :count).by(1)
      expect(response.content_type).to eq('text/javascript')
      expect(response).to be_successful
    end

  end



  context "GET #trash" do
    it "returns a success response" do
      get :trash
      expect(response).to be_successful
    end
  end



end
