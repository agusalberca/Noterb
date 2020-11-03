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
          if not Dir.exist?(File.join(Dir.home, "/.my_rns/#{name}"))
            Dir.mkdir(File.join(Dir.home, "/.my_rns/#{name}"))
            print ("BOOK CREATED: #{name} , PATH: "+ (File.join(Dir.home, "/.my_rns/", name )).to_s + "\n")
          else
            puts "Este libro ya existe"
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
            Dir.each_child(File.join(Dir.home, "/.my_rns/global")) do |x|
              arch=File.join(Dir.home, "/.my_rns/global/#{x}")
              puts "#{x} DELETED, Path:#{arch}"
              File.delete(arch)
            end
            puts "Las notas globales se han eliminado."
          else
            if name.nil?
              puts "Debe ingresar un book a borrar."
            else
              arch=File.join(Dir.home, "/.my_rns/#{name}")
              if File.exist?(arch)
                puts "#{name} BOOK DELETED, Path:#{arch}"
                Dir.delete(arch)
              else
                puts "#{name} BOOK NOT FOUND, Path:#{arch}"
              end
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
          Dir.each_child(File.join(Dir.home, "/.my_rns/")) {|x| puts x}
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
          if Dir.exist?(File.join(Dir.home, "/.my_rns/#{old_name}"))
            if not Dir.exist?(File.join(Dir.home, "/.my_rns/#{new_name}"))
              old=File.join(Dir.home, "/.my_rns/#{old_name}")
              new=File.join(Dir.home, "/.my_rns/#{new_name}")
              File.rename(old,new)
              puts "BOOK RENAMED: #{old_name} ->> #{new_name}"
            else
              puts "Book #{new_name} already exists."
            end
          else
            puts "Book #{old_name} does not exist."
          end
          # warn "TODO: Implementar renombrado del cuaderno de notas con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
