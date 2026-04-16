class ClientRate < ActiveRecord::Base
    belongs_to :rate
    belongs_to :client
    
end
