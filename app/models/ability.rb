class Ability
  include CanCan::Ability

  def initialize(user)

    return nil unless user # Fob off intrusive guests

    if user.admin?
      can :manage, :all
    else
      can :read, Competition, host_id: user.host_ids
      if JUMU_ROUND == 1
        can :create, Performance
        can :manage, Performance, competition: { host_id: user.host_ids }
      else
        # Authorize to read and list performances that advanced from own competition
        can [:read, :list_current], Performance, Performance.advanced_from_competition(user.competitions) do |p|
          user.competitions.include? p.predecessor.competition
        end
      end
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
