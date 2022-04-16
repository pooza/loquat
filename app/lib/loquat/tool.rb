module Loquat
  class Tool
    include Package

    def initialize
      @http = HTTP.new
    end

    def exec(args = {})
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def uri
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def fetch
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def path
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def save
      File.write(path, @entries.to_json)
    end

    def load
      @prev ||= JSON.parse(File.read(path))
      return @prev
    rescue
      return {}
    end

    alias prev load

    def help
      return ["-- #{self.class} のヘルプは未定義 --"]
    end

    def self.create(name)
      return "Loquat::#{name.camelize}Tool".constantize.new
    end

    def self.all
      return enum_for(__method__) unless block_given?
      config['/tools'].each do |name|
        yield create(name)
      end
    end
  end
end
