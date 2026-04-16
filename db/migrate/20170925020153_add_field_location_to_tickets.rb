class AddFieldLocationToTickets < ActiveRecord::Migration[5.2]
	change_table :tickets do |t|
		t.string :field_location
	end
end
