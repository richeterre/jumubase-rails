# -*- encoding : utf-8 -*-
class Jmd::HostsController < Jmd::BaseController

  load_and_authorize_resource

  def index
    # @hosts are fetched by CanCan
    @hosts = @hosts.order(:name)
  end


  def show
    # @host is fetched by CanCan
    @rw_contests = @host.contests.in_round(1).order("begins ASC")
    @lw_contests = @host.contests.in_round(2).order("begins ASC")
  end
end
