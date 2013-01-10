class Jmd::BaseController < ApplicationController
  check_authorization # All JMD actions must be authorized unless whitelisted
end
