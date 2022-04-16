module Loquat
  class ReservesTool < Tool
    def exec(args = {})
      @keyword = args.first
      @entries = {}
      fetch.select {|v| v.to_json.match?(@keyword)}.each do |entry|
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
      uri.path = '/api/reserves?isHalfWidth=false'
      return uri
    end

    def fetch
      return JSON.parse(@http.get(uri).body)['reserves']
    rescue => e
      logger.eror(error: e)
      return {}
    end

    def path
      return File.join(Environment.dir, 'tmp/cache', "reserves-#{@keyword.adler32}.json")
    end

    def help
      return [
        'bin/loquat.rb reserves phrase - 新規で予約された、番組情報にphraseを含む番組',
      ]
    end
  end
end
