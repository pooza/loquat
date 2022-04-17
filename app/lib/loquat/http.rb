module Loquat
  class HTTP < Ginseng::HTTP
    include Package

    def get(uri, params = {})
      response = super
      if params[:mock] && Environment.development? && Environment.test?
        path = self.class.create_mock_path(uri, params)
        File.write(path, Marshal.dump(response)) unless File.exist?(path)
      end
      return response
    rescue Ginseng::GatewayError => e
      if params[:mock] && Environment.ci?
        path = self.class.create_mock_path(uri, params)
        mock = Marshal.load(File.read(path)) # rubocop:disable Security/MarshalLoad
        warn "load mock: #{mock.class} #{File.basename(path)}"
        return mock
      end
      raise Ginseng::GatewayError, e.message, e.backtrace
    end

    def self.create_mock_path(uri, params = {})
      raise "request '#{uri}' not mockable" unless params[:mock]
      path = File.join(
        Environment.dir,
        'test/mock',
        params[:mock].to_s.underscore,
        params.merge(uri_path: uri.path).to_json.adler32,
      )
      FileUtils.mkdir_p(File.dirname(path))
      return path
    end
  end
end
