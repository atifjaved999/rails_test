class ListsController < ApplicationController
  before_action :set_list, only: [:edit, :update, :soft_delete, :destroy]

  before_action :set_lists, only: [:create, :update, :index, :soft_delete, :destroy]

  before_action :set_trash, only: [:trash, :restore]
  
  def index
  end

  def new
    @list = List.new
    3.times { @list.list_items.build }
    
    respond_to do |format|
      format.js {}
    end
  end

  def create
    @list = List.new(list_params)
    @list.save
    respond_to do |format|
      format.js {}
    end
  end

  def edit
    respond_to do |format|
      format.js {}
    end
  end

  def update
    @list.update(list_params)
    respond_to do |format|
      format.js {}
    end
  end

  def soft_delete
    @list.delete
    respond_to do |format|
      format.js {flash.now[:notice] = 'List was successfully destroyed (Soft Deleted).'}
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.js { flash.now[:notice] = 'List was successfully destroyed (Hard Deleted).' }
    end
  end

  def restore
    @list = List.only_deleted.find(params[:id])
    @list.restore
    respond_to do |format|
      format.js { flash.now[:notice] = 'List was successfully restored.' }
    end
  end

  def trash
  end


  private

  def set_lists
    @lists = List.includes(:list_items)
  end

  def set_list
    @list = List.find(params[:id])
  end

  def set_trash
    @deleted_lists = List.only_deleted
    @deleted_list_items = ListItem.only_deleted.joins(:list).where(lists: {deleted: false})
  end

  def list_params
    params.require(:list).permit(:name, list_items_attributes: [:id, :name])
  end

end
