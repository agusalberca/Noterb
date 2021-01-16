module RN
  class Note
    include PathFunctions
    require 'redcarpet'
    attr_accessor :title, :book

    def self.all(book = '*')
      Dir["#{PathFunctions.basePath}#{book}/*"].select { |e| File.file?(e) }.map do |note|
        File.basename(note)
      end
    end

    def self.all_paths(book = '*')
      Dir["#{PathFunctions.basePath}#{book}/*"].select { |e| File.file?(e) }
    end

    def self.export_all
      all_paths.map do | path |
        book = File.dirname(path).split('/').last
        Note.new(File.basename(path,'.*'), book).export
      end
    end

    def self.export_from_book(book)
      all_paths(book).map do | path |
        book = File.dirname(path).split('/').last
        Note.new(File.basename(path,'.*'), book).export
      end
    end

    def path
      "#{book.path}#{title}.rn"
    end

    def no_extention_path
      "#{book.path}#{title}"
    end

    def initialize(note_title, book = nil)
      self.title = note_title
      self.book = book.nil? ? Book.globalBook : Book.new(book)
    end

    def create
      File.new(path, 'w') unless File.exist?(path)
    end

    def delete
      File.delete(path) if File.exist?(path)
    end

    def edit
      TTY::Editor.new.open(path) if File.exist?(path)
    end

    def retitle(new_title)
      if File.exist?(path)
        File.rename(path, "#{book.path}#{new_title}.rn")
        self.title = new_title
      end
    end

    def show_note
      File.open(path).each { |line| puts line} if File.exist?(path)
    end

    def convert
      content = File.read(Dir["#{no_extention_path}.*"][0])
      md=Redcarpet::Markdown.new(Redcarpet::Render::HTML,tables: true)
      md.render(content)
    end

    def export(export_path = "#{book.path}.exported/")
      abort unless Dir.exist?(book.path)
      abort unless File.exist?(Dir["#{no_extention_path}.*"][0])
      unless File.exist?("#{export_path}#{title}.html")
        md = convert
        Dir.mkdir(export_path) unless Dir.exist?(export_path)
        File.open("#{export_path}#{title}.html", 'w') { |file| file.write md }
      end
    end
  end
end