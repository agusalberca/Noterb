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
          Book.new(name).create
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
          Book.new(book).delete
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
          Book.new(old_name).rename(new_name)
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
        end
      end
    end
  end
end
