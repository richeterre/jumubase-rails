module Api
  class ApiController < ActionController::Base
    # Prevent CSRF attacks by providing an empty session.
    protect_from_forgery with: :null_session

    before_filter :restrict_access

    private
      def restrict_access
        head :unauthorized unless request.headers['X-Api-Key'] == JUMU_MOBILE_API_KEY
      end
  end
end
