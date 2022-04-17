module Loquat
  class HTTP < Ginseng::HTTP
    include Package

    def get(uri, params = {})
      path = self.class.create_mock_path(uri, params)
      response = super
      if params[:mockable] && Environment.development? && Environment.test? && !File.exist?(path)
        File.write(path, Marshal.dump(response))
      end
      return response
    rescue Ginseng::GatewayError => e
      if params[:mockable] && Environment.ci? && File.exist?(path)
        mock = Marshal.load(File.read(path)) # rubocop:disable Security/MarshalLoad
        warn "load mock: #{mock.class} #{File.basename(path)}"
        return mock
      end
      raise Ginseng::GatewayError, e.message, e.backtrace
    end

    def self.create_mock_path(uri, params = {})
      return File.join(
        Environment.dir,
        'test/mock/http',
        params.merge(uri_path: uri.path).to_json.adler32,
      )
    end
  end
end
