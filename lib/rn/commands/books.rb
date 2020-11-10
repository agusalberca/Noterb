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
          if RN::GlobalFunctions.valid?(name)
            path=RN::GlobalFunctions.basePath + name
              if not Dir.exist?(path)
                Dir.mkdir(path)
                print ("BOOK CREATED: #{name}, PATH: #{path}" + "\n")
              else
                abort "This book already exists."
              end
          else
            abort "Book name contains forbidden character."
          end
          # warn "TODO: Implementar creación del cuaderno de notas con nombre '#{name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          if global
            Dir.each_child(RN::GlobalFunctions.basePathGlobal) do |x|
              arch=RN::GlobalFunctions.basePathGlobal + x
              puts "#{x} DELETED, PATH:#{arch}"
              File.delete(arch)
            end
            puts "All global notes have been deleted."
          else
            if not name == "global"
              if name.nil?
                abort "A book name or --global must be provided."
              else
                arch=RN::GlobalFunctions.basePath + name
                if File.exist?(arch)
                  puts "#{name} BOOK DELETED, PATH:#{arch}"
                  Dir.delete(arch)
                else
                  abort "#{name}: BOOK NOT FOUND"
                end
              end
            else
              puts "Global book cannot be deleted, to delete ALL global notes include --global in your options."
            end
          end
          # warn "TODO: Implementar borrado del cuaderno de notas con nombre '#{name}' (global=#{global}).\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          Dir.each_child(RN::GlobalFunctions.basePath) {|x| puts x}
          # warn "TODO: Implementar listado de los cuadernos de notas.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
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
          old=RN::GlobalFunctions.basePath + old_name
          new=RN::GlobalFunctions.basePath + new_name
          if not RN::GlobalFunctions.valid?(new_name)
            abort "New name: #{new_name} contains invalid characters."
          end
          if not old_name == "global"
            if Dir.exist?(old)
              if not Dir.exist?(new)
                File.rename(old,new)
                puts "BOOK RENAMED: #{old_name} ->> #{new_name}"
              else
                abort "Book #{new_name} already exists."
              end
            else
              abort "Book #{old_name} does not exist."
            end
          else
            abort "The global notebook cannot be renamed."
          end
          # warn "TODO: Implementar renombrado del cuaderno de notas con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
