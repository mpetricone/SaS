class Rate < ActiveRecord::Base
    has_many :client_rates
    validates :rate,  presence: true
end
