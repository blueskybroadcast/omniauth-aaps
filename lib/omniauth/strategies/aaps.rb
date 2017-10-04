require 'omniauth-oauth2'
require 'builder'
require 'nokogiri'
require 'rest_client'

module OmniAuth
  module Strategies
    class Aaps < OmniAuth::Strategies::OAuth2
      option :name, 'aaps'

      option :app_options, { app_event_id: nil }

      option :client_options, { login_page_url: 'MUST BE PROVIDED' }

      uid { info[:uid] }

      info { raw_user_info }

      def request_phase
        slug = session['omniauth.params']['origin'].gsub(/\//, '')
        redirect login_page_url + '?redirectURL=' + callback_url + "?slug=#{slug}"
      end

      def callback_phase
        slug = request.params['slug']
        account = Account.find_by(slug: slug)
        @app_event = account.app_events.where(id: options.app_options.app_event_id).first_or_create(activity_type: 'sso')

        self.env['omniauth.auth'] = auth_hash
        self.env['omniauth.origin'] = '/' + slug
        self.env['omniauth.app_event_id'] = @app_event.id

        finalize_app_event
        call_app!
      end

      def auth_hash
        hash = AuthHash.new(provider: name, uid: uid)
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
          uid: request.params['username'],
        }
      end

      private

      def login_page_url
        options.client_options.login_page_url
      end

      def finalize_app_event
        @app_event.update(
          raw_data: {
            user_info: {
              uid: info[:uid],
              email: info[:email],
              first_name: info[:first_name],
              last_name: info[:last_name],
              user_type: info[:user_type]
            }
          }
        )
      end
    end
  end
end
