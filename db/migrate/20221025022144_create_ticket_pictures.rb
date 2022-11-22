class CreateTicketPictures < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_pictures do |t|
      t.references :ticket, null: false, foreign_key: true
      t.text :description
      t.datetime :taken_at
      t.text :note

      t.timestamps
    end
  end
end
