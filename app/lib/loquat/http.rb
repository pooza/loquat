module Loquat
  class HTTP < Ginseng::HTTP
    include Package

    def get(uri, options = {})
      options[:headers] ||= {}
      options[:headers]['User-Agent'] ||= user_agent
      repeat(:get, uri = create_uri(uri), start = Time.now) do
        response = HTTParty.get(uri.normalize, options)
        log(method: :get, url: uri, status: response.code, start:)
        raise GatewayError, "Bad response #{response.code}" unless response.code < 400
        save_mock(response, options)
        return response
      end
    rescue => e
      return load_mock(error: e, options:)
    end
  end
end
