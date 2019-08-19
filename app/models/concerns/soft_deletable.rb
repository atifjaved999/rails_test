module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :not_deleted, -> { where(deleted: false) }
    default_scope { not_deleted }
    scope :only_deleted, -> { unscope(where: :deleted).where(deleted: true) }
  end

  def delete
    update deleted: true
  end

  def restore
    update(deleted: false)
  end

end