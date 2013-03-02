module AppearancesHelper
  # Return a badge with the appearance's age group
  def age_group_badge_tag(appearance)
    if appearance.accompaniment?
      info_badge_tag(appearance.age_group)
    else
      info_badge_tag(appearance.age_group, :info)
    end
  end
end
