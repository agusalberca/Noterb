module RN
  module GlobalFunctions
    def self.basePath
      return File.join(Dir.home, "/.my_rns/")
    end
    def self.basePathGlobal
      return File.join(Dir.home, "/.my_rns/global/")
    end
    def self.valid?(name)
      return (/[\W&&\S&&\D]+/ =~ name).nil?
    end
  end
end
