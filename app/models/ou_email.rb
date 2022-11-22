class OuEmail < ActiveRecord::Base
  belongs_to :ou
  validates :address , :presence => true
end
