module RN
  module PathFunctions

    def self.basePath
      return File.join(Dir.home, "/.my_rns/")
    end

    # Chequear que exista el cajon de notas
    unless Dir.exist?(self.basePath)
      Dir.mkdir(self.basePath)
      puts "Dir .my_rns creado en #{Dir.home}"
    end

    # chequear que exista book global(notas sin book)
    unless Dir.exist?("#{self.basePath}global")
      Dir.mkdir("#{self.basePath}global")
      puts "Book global creado en #{self.basePath}global"
    end



  end
  module Validators
    def self.valid_Name?(name)
      return (/[\W&&\S&&\D]+/ =~ name).nil?
    end
  end
end
