class Jmd::BaseController < ApplicationController
  before_filter :authenticate
end