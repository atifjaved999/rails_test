class ListItemsController < ApplicationController
  before_action :set_list_item, only: [:soft_delete, :destroy]
  before_action :set_lists, only: [:soft_delete, :destroy]

  before_action :set_trash, only: [:restore]

  def soft_delete
    @list_item.delete
    respond_to do |format|
      format.js {flash.now[:notice] = 'List Item was successfully destroyed (Soft Deleted).'}
    end
  end

  def destroy
    @list_item.destroy
    respond_to do |format|
      format.js { flash.now[:notice] = 'List Item was successfully destroyed (Hard Deleted).' }
    end
  end

  def restore
    @list_item = ListItem.only_deleted.find(params[:id])
    @list_item.restore
    respond_to do |format|
      format.js { flash.now[:notice] = 'List Item was successfully restored.' }
    end
  end

  private

  def set_lists
    @lists = List.includes(:list_items)
  end

  def set_trash
    @deleted_lists = List.only_deleted
    @deleted_list_items = ListItem.only_deleted.joins(:list).where(lists: {deleted: false})
  end

  def set_list_item
    @list_item = ListItem.find(params[:id])
  end

end