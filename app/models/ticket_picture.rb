class TicketPicture < ApplicationRecord
  belongs_to :ticket
  has_one_attached :image do |a|
    a.variant :thumb, resize_to_limit: [200, 200]
    a.variant :medium, resize_to_limit: [350, 350]
  end

  validates :image, presence: true
end
