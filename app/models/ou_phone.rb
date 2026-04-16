class OuPhone < ActiveRecord::Base
    belongs_to :ou
    validates :number, presence:  true
end
