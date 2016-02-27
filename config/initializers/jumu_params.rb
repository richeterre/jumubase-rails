# Jumu-related constants are defined here.
# Be sure to restart the server after changing any of these.

# The running number of the current competition season
JUMU_SEASON = Integer(ENV['JUMU_CURRENT_SEASON'])

# The current competition (ending) year
JUMU_YEAR = 1963 + JUMU_SEASON

# The upcoming/ongoing round for signup, timetables, etc.
JUMU_ROUND = Integer(ENV['JUMU_CURRENT_ROUND'])

# The point ranges for the different prizes
JUMU_PRIZE_POINT_RANGES = [
  # First round:
  {
    "1. Preis" => 21..25,
    "2. Preis" => 17..20,
    "3. Preis" => 13..16
  },
  # Second round:
  {
    "1. Preis" => 23..25,
    "2. Preis" => 20..22,
    "3. Preis" => 17..19
  }
]

# The point ranges for the different predicates
JUMU_PREDICATE_POINT_RANGES = [
  # First round:
  {
    "mit gutem Erfolg teilgenommen" => 9..12,
    "mit Erfolg teilgenommen" => 5..8,
    "teilgenommen" => 0..4
  },
  # Second round:
  {
    "mit gutem Erfolg teilgenommen" => 14..16,
    "mit Erfolg teilgenommen" => 11..13,
    "teilgenommen" => 0..10
  }
]

# Mapping from old role slugs to identifiers used in mobile API
JUMU_PARTICIPANT_ROLE_MAPPING = {
  "S" => 'soloist',
  "E" => 'ensemblist',
  "B" => 'accompanist'
}

# Possible age group values
JUMU_AGE_GROUPS = %w(Ia Ib II III IV V VI VII)

# Whether signup and tracing-code editing are possible
JUMU_SIGNUP_OPEN = ENV['JUMU_SIGNUP_OPEN'].to_bool

# Whether results for the above round are available
JUMU_RESULTS_AVAILABLE = ENV['JUMU_RESULTS_AVAILABLE'].to_bool

# Whether timetables for the above round are public
JUMU_TIMETABLES_VISIBLE = ENV['JUMU_TIMETABLES_VISIBLE'].to_bool
# The 2nd round host
JUMU_HOST = ENV['JUMU_CURRENT_LW_HOST']

# The core organization team's mail addresses
JUMU_CONTACT_EMAIL = ENV['JUMU_CONTACT_EMAIL']
