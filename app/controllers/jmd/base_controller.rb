class Jmd::BaseController < ApplicationController
  # All inside features require authentication (not necessarily admin)
  before_filter :authenticate
end
