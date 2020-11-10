module RN
  module GlobalFunctions
    def self.basePath
      return File.join(Dir.home, "/.my_rns/")
    end
    def self.basePathGlobal
      return File.join(Dir.home, "/.my_rns/global/")
    end

  end
  module Validators
    def self.valid_Name?(name)
      return (/[\W&&\S&&\D]+/ =~ name).nil?
    end
  end
end
