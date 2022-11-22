class CreateDistributers < ActiveRecord::Migration[5.2]
  def change
    create_table :distributers do |t|
      t.string :name
      t.string :min_purchase
      t.string :min_purchase_freq
      t.date :date_enabled
      t.date :date_disabled

      t.timestamps
    end
  end
end
