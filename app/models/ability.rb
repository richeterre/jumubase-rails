class Ability
  include CanCan::Ability

  def initialize(user)

    return nil unless user # Fob off intrusive guests

    if user.admin?
      can :manage, :all
    else
      can :read, Competition, host_id: user.host_ids
      can :create, Performance
      can :manage, Performance, competition: { host_id: user.host_ids }
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
