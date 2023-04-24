require 'httparty'

module Pandadoc
  module Api
    class Client
      def get(path, token, params = {})
        uri = build_uri(path)
        response = HTTParty.get(uri, headers: default_headers(token), query: params)
        puts "\n\n#{__FILE__}:#{__LINE__} - #{response.request.last_uri}\n\n"
        response
      end

      def post_json(path, token, params = {})
        uri = build_uri(path)
        headers = default_headers(token).merge('Content-Type' => 'application/json')
        HTTParty.post(uri, headers: headers, body: params.to_json)
      end

      def delete(path, token)
        uri = build_uri(path)
        HTTParty.delete(uri, headers: default_headers(token))
      end

      private

      def default_headers(token)
        auth_string = if token.match(/^API-Key/)
          token
        else
          "Bearer #{token}"
        end
        
        {
          'Authorization' => auth_string
        }
      end

      def build_uri(path)
        File.join(Pandadoc::Api::API_ROOT, path)
      end
    end
  end
end
