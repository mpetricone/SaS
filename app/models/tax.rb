class Tax < ActiveRecord::Base
    has_many :ous
    validates :rate, presence: true
    validates :name, presence: true
    validates :region, presence: true

    def description
        "#{rate} #{name}"
    end
end
