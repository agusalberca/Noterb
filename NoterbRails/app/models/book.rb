require 'rubygems'
require 'zip'

class Book < ApplicationRecord
  has_many :notes, dependent: :destroy
  belongs_to :user, foreign_key: 'user_id'
  validates :name, presence: true

  def to_s
    name
  end

  def global?
    name == 'Global'
  end

  def export_as_zip
    compiled_file = Zip::OutputStream.write_buffer do |zip_file|
      self.notes.each do |note|
        zip_file.put_next_entry("#{note.title}.html")
        zip_file << note.export_html
      end
    end
    compiled_file.rewind
    data = compiled_file.sysread
  end

end
