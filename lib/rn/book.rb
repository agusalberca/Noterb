module RN
  class Book
    include PathFunctions
    GLOBAL_BOOK_NAME = 'global'.freeze

    attr_accessor :name

    def self.globalBook
      new GLOBAL_BOOK_NAME
    end

    def self.from_directory(path)
      File.basename(path)
    end

    def self.all
      books = Dir["#{PathFunctions.basePath}/*"].select { |e| File.directory?(e) }.map do |book_path|
        Book.from_directory(book_path)
      end
      books
    end

    def path
      "#{PathFunctions.basePath}#{name}/"
    end

    def initialize(name = GLOBAL_BOOK_NAME)
      self.name = name
    end

    def global?
      name == GLOBAL_BOOK_NAME
    end

    def create
      Dir.mkdir(path) unless Dir.exist?(path)
      # print ("BOOK CREATED: #{name}, PATH: #{path} \n")
    end

    def delete
      if global?
        Dir.each_child(path) do |x|
          arch = "#{path}/#{x}"
          File.delete(arch)
          # puts "NOTE DELETED: #{x}, PATH:#{arch}"
        end
        # puts 'All global notes have been deleted.'
      elsif File.exist?(path)
        FileUtils.rm_r(path)
        # puts "BOOK DELETED: #{name} , PATH:#{path}"
      end
    end

    def rename(new_name)
      abort if name == 'global'
      if Dir.exist?(path)
        unless Dir.exist?("#{PathFunctions.basePath}#{new_name}/")
          File.rename(path, "#{PathFunctions.basePath}#{new_name}/")
          self.name = new_name
        end
      end
    end

    def export
      Note.export_from_book(name)
      # puts "BOOK: #{name} -> finished exporting process."
    end
  end
end