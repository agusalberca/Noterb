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
      unless RN::Validators.valid_Name?(self.name)
        abort 'Book name contains forbidden character.'
      end
      if !Dir.exist?(path)
        Dir.mkdir(path)
        print ("BOOK CREATED: #{name}, PATH: #{path} \n")
      else
        abort 'This book already exists.'
      end
    end

    def delete
      if global?
        Dir.each_child(path) do |x|
          arch = "#{path}/#{x}"
          File.delete(arch)
          puts "NOTE DELETED: #{x}, PATH:#{arch}"
        end
        puts 'All global notes have been deleted.'
      elsif File.exist?(path)
        FileUtils.rm_r(path)
        puts "BOOK DELETED: #{name} , PATH:#{path}"
      else
        abort "Book #{name} does not exist."
      end
    end

    def rename(new_name)
      if !RN::Validators.valid_Name?(new_name)
        abort "New name: #{new_name} contains invalid characters."
      end
      if name == 'global'
        abort 'The global notebook cannot be renamed.'
      end
      if Dir.exist?(path)
        if !Dir.exist?("#{PathFunctions.basePath}#{new_name}/")
          File.rename(path, "#{PathFunctions.basePath}#{new_name}/")
          old_name=name
          name=new_name
          puts "BOOK RENAMED: #{old_name} ->> #{name}"
        else
          abort "Book #{new_name} already exists."
        end
      else
        abort "Book #{name} does not exist."
      end
    end
  end
end