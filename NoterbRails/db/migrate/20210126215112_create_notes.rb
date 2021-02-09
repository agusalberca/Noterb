class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
