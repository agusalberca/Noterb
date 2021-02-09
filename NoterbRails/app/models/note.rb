class Note < ApplicationRecord
  belongs_to :book, foreign_key: 'book_id', optional: true
  belongs_to :user, foreign_key: 'user_id'

  validates :title, presence: true


  def export_html
    text = "#{self.title} <br> #{self.content}"
    md=Redcarpet::Markdown.new(Redcarpet::Render::HTML,tables: true)
    data = md.render(text)
    # File.open("note_#{title}.html", 'w') { |file| file.write md }
    return data
  end

  def export_as_file
    File.open("note_#{title}.html", 'w') { |file| file.write self.export_html }
  end
end
