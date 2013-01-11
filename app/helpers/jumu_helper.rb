module JumuHelper

  def calculate_age_group(birthdates)
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
    lookup_age_group(avg_date)
  end

  def lookup_age_group(date)
    case date.year
    when (JUMU_YEAR - 8)..JUMU_YEAR
      "Ia"
    when (JUMU_YEAR - 10)..(JUMU_YEAR - 9)
      "Ib"
    when (JUMU_YEAR - 12)..(JUMU_YEAR - 11)
      "II"
    when (JUMU_YEAR - 14)..(JUMU_YEAR - 13)
      "III"
    when (JUMU_YEAR - 16)..(JUMU_YEAR - 15)
      "IV"
    when (JUMU_YEAR - 18)..(JUMU_YEAR - 17)
      "V"
    when (JUMU_YEAR - 21)..(JUMU_YEAR - 19)
      "VI"
    when (JUMU_YEAR - 27)..(JUMU_YEAR - 22)
      "VII"
    end
  end
end
