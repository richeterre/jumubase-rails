class Jmd::BaseController < ApplicationController
  # All JMD features require authentication (not necessarily admin)
  before_filter :authenticate
end