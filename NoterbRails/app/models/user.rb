class User < ApplicationRecord

  has_many :books, dependent: :destroy, inverse_of: :user
  has_many :notes, dependent: :destroy, inverse_of: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_global

  def create_global
    self.books.create(name: 'Global')
  end

  def export_data_zip
    compiled_file = Zip::OutputStream.write_buffer do |zip_file|
      self.books.each do |book|
        zip_file.put_next_entry("#{book.name}.zip")
        zip_file << book.export_as_zip
      end
    end
    compiled_file.rewind
    data = compiled_file.sysread
  end
end
