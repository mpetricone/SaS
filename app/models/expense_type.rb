class ExpenseType < ActiveRecord::Base
    validates :name, presence: true
end
