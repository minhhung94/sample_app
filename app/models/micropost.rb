class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :recent_posts, -> {order created_at: :desc}
  validates :user_id, presence: true
  validates :content, presence: true,
    length: { maximum: Settings.micropost.model.content_max_length }
  validates :image, content_type: {
    in: Settings.micropost.model.content_type,
    message: I18n.t("microposts.model.image.type")},
    size:  { less_than: Settings.micropost.model.image_size_mb.megabytes,
      message: I18n.t("microposts.model.image.size") }

  # Returns a resized image for display.
  def display_image
    image.variant resize_to_limit: [Settings.micropost.model.display_img.height,
      Settings.micropost.model.display_img.width]
  end
end
