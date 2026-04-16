class CreateShipmentTrackings < ActiveRecord::Migration[5.2]
  def change
    create_table :shipment_trackings do |t|
      t.references :ticket, index: true
      t.string :tracking_number
      t.datetime :date_shipped
      t.integer :item_count

      t.timestamps
    end
  end
end
