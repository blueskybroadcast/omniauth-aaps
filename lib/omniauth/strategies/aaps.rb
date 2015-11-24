require 'omniauth-oauth2'
require 'builder'
require 'nokogiri'
require 'rest_client'

module OmniAuth
  module Strategies
    class Aaps < OmniAuth::Strategies::OAuth2
      option :name, 'aaps'

      option :client_options, { login_page_url: 'MUST BE PROVIDED' }

      uid { info[:username] }

      info { raw_user_info }

      def request_phase
        slug = session['omniauth.params']['origin'].gsub(/\//,"")
        redirect authorize_url + "?returnURL=" + callback_url + "?slug=#{slug}"
      end

      def callback_phase
        self.env['omniauth.auth'] = auth_hash
        self.env['omniauth.origin'] = '/' + request.params['slug']
        call_app!
      end

      def auth_hash
        hash = AuthHash.new(:provider => name, :uid => uid)
        hash.info = info
        hash
      end

      def raw_user_info
        {
          first_name: request.params['first_name'],
          last_name: request.params['last_name'],
          email: request.params['email'],
          user_type: request.params['user_type'],
          username: request.params['username'],
        }
      end

      private

      def authorize_url
        options.client_options.login_page_url
      end

    end
  end
end
