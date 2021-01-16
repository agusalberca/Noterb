module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          abort 'Note title contains forbidden character.' unless RN::Validators.valid_Name?(title)
          work_note = Note.new(title, book)
          abort "Book #{work_note.book.name} does not exist." unless Dir.exist?(work_note.book.path)
          abort "Note #{title} already exists in book #{work_note.book.name}." if File.exist?(work_note.path)
          work_note.create
          puts "NOTE CREATED: #{title}, BOOK: #{work_note.book.name}, PATH: #{work_note.path}"
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          work_note = Note.new(title, book)
          abort "Book #{book.name} does not exist." unless Dir.exist?(work_note.book.path)
          abort "Note #{title} does not exist in book #{work_note.book.name}." unless File.exist?(work_note.path)
          work_note.delete
          puts "NOTE DELETED: #{title}, BOOK: #{work_note.book.name}, PATH: #{work_note.path}"
        end
      end
      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          work_note = Note.new(title, book)
          abort "Book #{work_note.book.name} does not exist." unless Dir.exist?(work_note.book.path)
          abort "Note #{title} does not exist in book #{work_note.book.name}." unless File.exist?(work_note.path)
          work_note.edit
          puts "NOTE EDITED: #{title}, PATH: #{work_note.path}"
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          abort "Note title \"#{new_title}\" contains forbidden character." unless RN::Validators.valid_Name?(new_title)
          work_note = Note.new(old_title, book)
          abort "Book #{work_note.book.name} does not exist." unless Dir.exist?(work_note.book.path)
          abort "Note #{work_note.title} does not exist in book #{work_note.book.name}." unless File.exist?(work_note.path)
          abort "Note #{new_title} already exists in book #{work_note.book.name}." if  File.exist?("#{work_note.book.path}#{new_title}.rn")
          work_note.retitle(new_title)
          puts "NOTE RETITLED: #{old_title} ->> #{new_title}, PATH: #{work_note.path}"
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          if book.nil? and !global
            puts Note.all
          else
            list_book=book.nil? ? Book.globalBook : book
            puts Note.all(list_book)
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          work_note = Note.new(title, book)
          abort "Book #{work_note.book.name} does not exist." unless Dir.exist?(work_note.book.path)
          abort "Note #{title} does not exist in book #{work_note.book.name}." unless File.exist?(work_note.path)
          work_note.show_note
        end
      end

      class Export < Dry::CLI::Command
        desc 'Export notes'

        argument :title, required: false, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
                    'todo                        # Exports a note titled "todo" from the global book',
                    '"New note" --book "My book" # Exports a note titled "New note" from the book "My book"',
                    'thoughts --book Memoires    # Exports a note titled "thoughts" from the book "Memoires"'
                ]

        def call(title: nil, **options)
          book = options[:book]

          if book.nil? and title.nil?
            Note.export_all
            puts "All notes have been exported."
          else
            work_note = Note.new(title, book)
            export_path = "#{work_note.book.path}.exported/"
            abort "Book #{work_note.book.name} does not exist." unless Dir.exist?(work_note.book.path)
            abort "Note #{title} does not exist in book #{work_note.book.name}." unless File.exist?(Dir["#{work_note.no_extention_path}.*"][0])
            puts "File #{title} already exported. PATH: #{export_path}#{title}.html" if File.exist?("#{export_path}#{title}.html")
            work_note.export
            puts "NOTE EXPORTED: #{title}, PATH: #{export_path}#{title}.html"
          end
        end
      end
    end
  end
end
