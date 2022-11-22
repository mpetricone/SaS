class CreateTicketNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_notes do |t|
      t.string :subject
      t.text :body
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
