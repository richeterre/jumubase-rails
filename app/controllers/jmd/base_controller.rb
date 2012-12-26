class Jmd::BaseController < ApplicationController
  check_authorization # Inside features are whitelisted
end
