class List < ApplicationRecord
  has_many :list_items, dependent: :destroy
  accepts_nested_attributes_for :list_items, allow_destroy: true
  
  validates :name, presence: true

  include SoftDeletable

  after_update :soft_delete_list_items, :restore_list_items
  
  def soft_delete_list_items
    list_items.each(&:delete) if deleted
  end

  def restore_list_items
    list_items.only_deleted.each(&:restore) unless deleted
  end

end
