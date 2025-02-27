class Setting < ApplicationRecord
  has_rich_text :about_text
  has_one_attached :profile_image
  has_one_attached :banner_image
  validate :only_one_row, on: :create
  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete("site_setting")
  end

  def only_one_row
    if self.class.exists?
      errors.add(:base, "Only one record is allowed")
    end
  end
end
