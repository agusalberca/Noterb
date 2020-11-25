module RN
  module PathFunctions
    def self.basePath
      return File.join(Dir.home, "/.my_rns/")
    end

  end
  module Validators
    def self.valid_Name?(name)
      return (/[\W&&\S&&\D]+/ =~ name).nil?
    end
  end
end
