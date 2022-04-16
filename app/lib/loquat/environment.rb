module Loquat
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return Loquat.dir
    end
  end
end
