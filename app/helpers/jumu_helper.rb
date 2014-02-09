module JumuHelper

  def calculate_age_group(birthdates, season)
    if birthdates.instance_of? Date
      # Skip averaging step if only one date
      avg_date = birthdates
    else
      # Convert dates to timestamps
      timestamps = birthdates.map{ |date| date.to_time.to_i }
      # Get "average" date
      avg_timestamp = timestamps.sum.to_f / birthdates.size
      avg_date = Time.at(avg_timestamp).to_date
    end
    # Return age group for that date
    lookup_age_group(avg_date, season)
  end

  def lookup_age_group(date, season)
    jumu_year = lookup_jumu_year(season)

    case date.year
    when (jumu_year - 8)..jumu_year
      JUMU_AGE_GROUPS[0]
    when (jumu_year - 10)..(jumu_year - 9)
      JUMU_AGE_GROUPS[1]
    when (jumu_year - 12)..(jumu_year - 11)
      JUMU_AGE_GROUPS[2]
    when (jumu_year - 14)..(jumu_year - 13)
      JUMU_AGE_GROUPS[3]
    when (jumu_year - 16)..(jumu_year - 15)
      JUMU_AGE_GROUPS[4]
    when (jumu_year - 18)..(jumu_year - 17)
      JUMU_AGE_GROUPS[5]
    when (jumu_year - 21)..(jumu_year - 19)
      JUMU_AGE_GROUPS[6]
    when (jumu_year - 27)..(jumu_year - 22)
      JUMU_AGE_GROUPS[7]
    end
  end

  def lookup_jumu_year(season)
    return JUMU_YEAR - JUMU_SEASON + season
  end
end
