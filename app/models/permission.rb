class Permission < ActiveRecord::Base
    validates :name, uniqueness: true
end
