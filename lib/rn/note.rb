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

    def self.all_paths
      Dir["#{PathFunctions.basePath}*/*"].select { |e| File.file?(e) }
    end

    def self.export_all
      all_paths.map do | path |
        book = File.dirname(path).split('/').last
        Note.new(File.basename(path,".*"), book).export
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
      if !RN::Validators.valid_Name?(title)
        abort 'Note title contains forbidden character.'
      end
      if Dir.exist?(book.path)
        if !File.exist?(path)
          File.new(path,'w')
          puts "NOTE CREATED: #{title}, BOOK: #{book.name}, PATH: #{path}"
        else
          abort "Note #{title} already exists in book #{book.name}."
        end
      else
        abort "Book #{book.name} does not exist."
      end
    end
    def delete
      if Dir.exist?(book.path)
        if File.exist?(path)
          File.delete(path)
          puts "NOTE DELETED: #{title}, BOOK: #{book.name}, PATH: #{path}"
        else
          abort "Note #{title} does not exist in book #{book.name}."
        end
      else
        abort "Book #{book.name} does not exist."
      end
    end

    def edit
      if Dir.exist?(book.path)
        if File.exist?(path)
          editor = TTY::Editor.new.open(path)
          puts "NOTE EDITED: #{title}, PATH: #{path}"
        else
          abort "Note #{title} does not exist in book #{book.name}."
        end
      else
        abort "Book #{book.name} does not exist."
      end
    end

    def retitle(new_title)
      if !RN::Validators.valid_Name?(new_title)
        abort "Note title \"#{new_title}\" contains forbidden character."
      end
      if Dir.exist?(book.path)
        if File.exist?(path)
          if not File.exist?("#{book.path}#{new_title}.rn")
            File.rename(path,"#{book.path}#{new_title}.rn")
            old_title=title
            self.title=new_title
            puts "NOTE RENAMED: #{old_title} ->> #{title}, PATH: #{path}"
          else
            abort "Note #{new_title} already exists in book #{book.name}."
          end
        else
          abort "Note #{title} does not exist in book #{book.name}."
        end
      else
        abort "Book #{book.name} does not exist."
      end
    end

    def show_note
      if Dir.exist?(book.path)
        if File.exist?(path)
          File.open(path).each { |line| puts line}
        else
          abort "Note #{title} does not exist in book #{book.name}."
        end
      else
        abort "Book #{book.name} does not exist."
      end
    end

    def convert
      content = File.read(Dir["#{no_extention_path}.*"][0])
      md=Redcarpet::Markdown.new(Redcarpet::Render::HTML,tables: true)
      md.render(content)
    end

    def export(export_path = "#{book.path}.exported/")
      if Dir.exist?(book.path)
        if File.exist?(Dir["#{no_extention_path}.*"][0])
          if !File.exist?("#{export_path}#{title}.html")
            md = convert
            Dir.mkdir(export_path) unless Dir.exist?(export_path)
            File.open("#{export_path}#{title}.html", 'w') { |file| file.write md }
            puts "NOTE EXPORTED: #{title}, PATH: #{export_path}#{title}.html"
          else
            puts "File #{title} already exported. PATH: #{export_path}#{title}.html"
          end
        else
          abort "Note #{title} does not exist in book #{book.name}."
        end
      else
        abort "Book #{book.name} does not exist."
      end
    end
  end
end