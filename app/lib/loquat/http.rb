module Loquat
  class HTTP < Ginseng::HTTP
    include Package

    def get(uri, params = {})
      path = self.class.create_mock_path(uri, params)
      response = super
      File.write(path, Marshal.dump(response)) unless File.exist?(path)
      return response
    rescue Ginseng::GatewayError => e
      if Environment.ci? && File.exist?(path)
        ic mock = Marshal.load(File.read(path)) # rubocop:disable Security/MarshalLoad
        return mock
      end
      raise Ginseng::GatewayError, e.message, e.backtrace
    end

    def self.create_mock_path(uri, params = {})
      return File.join(
        Environment.dir,
        'tmp/mock/http',
        params.merge(uri_path: uri.path).to_json.adler32,
      )
    end
  end
end
