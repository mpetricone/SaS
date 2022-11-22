class OuAddress < ActiveRecord::Base
    belongs_to :address
    belongs_to :ou
    accepts_nested_attributes_for :address
end
