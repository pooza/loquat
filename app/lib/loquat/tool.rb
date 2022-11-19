require 'optparse'

module Loquat
  class Tool
    include Package
    attr_accessor :keyword

    def initialize
      @http = HTTP.new
    end

    def exec(args = [])
      args.shift if args.present?
      @keyword = args.shift if args.present?
      @options = args.getopts('n') rescue {}
      dest = entries.reject {|id, _| prev.member?(id)}.values.map {|v| v.join("\n")}
      save if save?
      return dest.join("\n---\n")
    end

    def uri
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def fetch
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def save?
      return @options['n'] != true
    end

    def path
      raise Ginseng::ImplementError, "'#{__method__}' not implemented"
    end

    def save
      File.write(path, entries.to_json)
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

    def self.create_entry(row)
      row = {
        name: row['name'].gsub(/\R/, "\n"),
        start: row['startAt'].to_time.strftime('%m/%d %H:%M'),
        end: row['endAt'].to_time.strftime('%H:%M'),
        description: row['description']&.gsub(/\R/, "\n"),
      }
      return [
        row[:name],
        "#{row[:start]} 〜 #{row[:end]}",
        row[:description],
      ].compact.reject {|v| v.is_a?(String) && v.match?(/^[[:blank:]]+$/)}
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
