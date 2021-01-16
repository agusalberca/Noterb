module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]
        def call(name:, **)
          unless RN::Validators.valid_Name?(name)
            abort 'Book name contains forbidden character.'
          end
          new_book = Book.new(name)
          if Dir.exist?(new_book.path)
            abort 'This book already exists.'
          end
          new_book.create
          print ("BOOK CREATED: #{new_book.name}, PATH: #{new_book.path} \n")
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if global && (not name.nil?)
            abort 'Argument & option conflict. Avoid using them simultaneously.'
          end
          work_book = Book.new(name)
          unless File.exist?(work_book.path)
            abort "Book #{name} does not exist."
          end

          if global
            book = 'global'
            puts 'All global notes have been deleted.'
          else
            if not name.nil?
              if name == 'global'
                abort 'Global book cannot be deleted, to delete ALL global notes include --global in your options.'
              end
              book = name
              puts "BOOK DELETED: #{name} , PATH:#{work_book.path}"
            else
              abort 'A name or --global must be provided.'
            end
          end
          work_book.delete
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]
        def call(*)
          Book.all.map { |each| puts each }
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          work_book = Book.new(old_name)
          unless RN::Validators.valid_Name?(new_name)
            abort "New name: #{new_name} contains invalid characters."
          end
          abort 'The global notebook cannot be renamed.' if old_name == 'global'
          abort "Book #{work_book.name} does not exist." unless Dir.exist?(work_book.path)
          abort "Book #{new_name} already exists." if Dir.exist?("#{PathFunctions.basePath}#{new_name}/")
          work_book.rename(new_name)
          puts "BOOK RENAMED: #{old_name} ->> #{work_book.name}"
        end
      end

      class Export < Dry::CLI::Command
        desc 'Export a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
                    '--global  # Exports all notes from the global book',
                    '"My book" # Exports all notes from book named "My book"',
                    'Memoires  # Exports all notes from book named "Memoires"'
                ]

        def call(name: nil, **options)
          global = options[:global]
          if global && (not name.nil?)
            abort 'Argument & option conflict. Avoid using them simultaneously.'
          end
          if global
            book = 'global'
          else
            if not name.nil?
              if name == 'global'
                abort 'Global book cannot be deleted, to delete ALL global notes include --global in your options.'
              end
              book = name
            else
              abort 'A name or --global must be provided.'
            end
          end
          Book.new(book).export
          puts "BOOK: #{name} -> finished exporting process."
        end
      end
    end
  end
end
