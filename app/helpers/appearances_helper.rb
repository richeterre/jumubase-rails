module AppearancesHelper
  # Return whether a performance filter is currently active
  def age_group_badge_tag(appearance)
    if appearance.accompaniment?
      info_badge_tag(appearance.age_group)
    else
      info_badge_tag(appearance.age_group, :info)
    end
  end
end
