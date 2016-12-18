class Ability
  include CanCan::Ability

  def initialize(user)

    return nil unless user # Fob off intrusive guests

    if user.admin?
      can :manage, :all
    else
      can :read, Contest, host_id: user.host_ids
      can :read, Participant # TODO: Should allow only "own" participants
      can :read, :welcome

      if JUMU_ROUND == 1
        can :create, Performance # TODO: Check that user has access to selected contest
        can :manage, Performance, contest_category: { contest: { host_id: user.host_ids } }
        can :show_timetables, Contest, host_id: user.host_ids
        can :schedule, Venue, host_id: user.host_ids
      else
        # Authorize to read and list performances that advanced from own contest
        can [:read, :list_current], Performance, Performance.advanced_from_contest(user.contests) do |p|
          user.contests.include? p.predecessor.contest
        end
        # Authorize to see list of advancing performances from own contests
        can [:list_advancing], Contest, host_id: user.host_ids
      end
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
