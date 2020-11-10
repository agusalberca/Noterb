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
          if not RN::Validators.valid_Name?(title)
            abort "Note title contains forbidden character."
          end
          if not book.nil?
            bookPath=RN::GlobalFunctions.basePath + book + "/"
          else
            bookPath=RN::GlobalFunctions.basePathGlobal
            book= "global"
          end
          if Dir.exist?(bookPath)
            ntPath=bookPath + title +".rn"
            if not File.exist?(ntPath)
              File.new(ntPath,"w")
              puts "NOTE CREATED: #{title}, BOOK: #{book}, PATH: #{ntPath}"
            else
              abort "Note #{title} already exists in book #{book}."
            end
          else
            abort "Book #{book} does not exist."
          end
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
          if not book.nil?
            bookPath=RN::GlobalFunctions.basePath + book + "/"
          else
            bookPath=RN::GlobalFunctions.basePathGlobal
            book= "global"
          end
          if Dir.exist?(bookPath)
            ntPath=bookPath + title + ".rn"
            if File.exist?(ntPath)
              File.delete(ntPath)
              puts "NOTE DELETED: #{title}, BOOK: #{book}, PATH: #{ntPath}"
            else
              abort "Note #{title} does not exist in book #{book}."
            end
          else
            abort "Book #{book} does not exist."
          end
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
          if not book.nil?
            bookPath=RN::GlobalFunctions.basePath + book + "/"
          else
            bookPath=RN::GlobalFunctions.basePathGlobal
            book= "global"
          end
          if Dir.exist?(bookPath)
            ntPath=bookPath + title +".rn"
            if File.exist?(ntPath)
              editor = TTY::Editor.new()
              editor.open(ntPath)
              puts "NOTE EDITED: #{title}, PATH: #{ntPath}"
            else
              abort "Note #{title} does not exist in book #{book}."
            end
          else
            abort "Book #{book} does not exist."
          end
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
          if not RN::Validators.valid_Name?(new_title)
            abort "Note title \"#{new_title}\" contains forbidden character."
          end
          if not book.nil?
            bookPath=RN::GlobalFunctions.basePath + book + "/"
          else
            bookPath=RN::GlobalFunctions.basePathGlobal
            book="global"
          end
          if Dir.exist?(bookPath)
            ntPathOld=bookPath + old_title +".rn"
            if File.exist?(ntPathOld)
              ntPathNew=bookPath + new_title +".rn"
              if not File.exist?(ntPathNew)
                File.rename(ntPathOld,ntPathNew)
                puts "NOTE RENAMED: #{old_title} ->> #{new_title}, PATH: #{ntPathNew}"
              else
                abort "Note #{new_title} already exists in book #{book}."
              end
            else
              abort "Note #{old_title} does not exist in book #{book}."
            end
          else
            abort "Book #{book} does not exist."
          end
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

          # warn "TODO: Implementar listado de las notas del libro '#{book}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          warn "TODO: Implementar vista de la nota con título '#{title}' (del libro '#{book}').\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
