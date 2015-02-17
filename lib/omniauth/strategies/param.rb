require 'omniauth'

module OmniAuth
  module Strategies
    class Param
      include OmniAuth::Strategy

      def request_phase
        redirect callback_url
      end

      uid do
        auth_params["uid"]
      end

      info do
        {
          :name => auth_params["name"]
        }
      end

      private

      def auth_params
        if env['omniauth.params']
          return env['omniauth.params']
        else
          fail!(:missing_params)
        end
      end
    end
  end
end
