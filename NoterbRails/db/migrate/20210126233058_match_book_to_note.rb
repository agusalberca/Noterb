class MatchBookToNote < ActiveRecord::Migration[6.1]
  def change
    add_reference :notes, :book, foreign_key: true
  end
end
