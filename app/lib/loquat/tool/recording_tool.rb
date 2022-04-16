module Loquat
  class RecordingTool < Tool
    def exec(args = {})
      @entries = {}
      fetch.each do |entry|
        @entries[entry.to_json.adler32] = {
          '題名' => entry['name'].gsub(/\R/, "\n"),
          '開始' => entry['startAt'].to_time.strftime('%m/%d %H:%M'),
          '終了' => entry['endAt'].to_time.strftime('%m/%d %H:%M'),
          '概要' => entry['description']&.gsub(/\R/, "\n"),
        }.compact.reject {|_k, v| v.is_a?(String) && v.match?(/^[[:blank:]]+$/)}
      end
      dest = @entries.reject {|id, _| prev.member?(id)}.transform_values(&:to_yaml)
      save
      return dest.values.join
    end

    def uri
      uri = Ginseng::URI.parse(config['/epg_station/url'])
      uri.path = '/api/recording?isHalfWidth=false'
      return uri
    end

    def fetch
      return JSON.parse(@http.get(uri).body)['records']
    rescue => e
      logger.eror(error: e)
      return {}
    end

    def path
      return File.join(Environment.dir, 'tmp/cache', "recording.json")
    end

    def help
      return [
        'bin/loquat.rb recording - 録画中の番組',
      ]
    end
  end
end
