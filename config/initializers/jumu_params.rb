# Jumu-related constants are defined here.
# Be sure to restart the server after changing any of these.

# The running number of the current competition season
JUMU_SEASON = Integer(ENV['JUMU_CURRENT_SEASON'])

# The current competition (ending) year
JUMU_YEAR = 1963 + JUMU_SEASON

# The upcoming/ongoing round for signup, timetables, etc.
JUMU_ROUND = Integer(ENV['JUMU_CURRENT_ROUND'])

# The names of the different rounds
JUMU_ROUND_NAMES = {
  1 => "Regionalwettbewerb",
  2 => "Landeswettbewerb",
  3 => "Bundeswettbewerb"
}

# The short names of the different rounds
JUMU_ROUND_SHORT_NAMES = {
  1 => "RW",
  2 => "LW",
  3 => "BW"
}

# The names of the different rounds' boards
JUMU_ROUND_BOARD_NAMES = {
  1 => "Regionalausschuss",
  2 => "Landesausschuss"
}

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

# Possible participant role values for the database
JUMU_PARTICIPANT_ROLES = %w(soloist accompanist ensemblist)

# Possible piece epochs
JUMU_EPOCHS = %w(a b c d e f)

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

# The site's administrator info
JUMU_ADMIN_NAME = ENV['JUMU_ADMIN_NAME']
JUMU_ADMIN_EMAIL = ENV['JUMU_ADMIN_EMAIL']

# The core organization team's mail addresses
JUMU_CONTACT_EMAIL = ENV['JUMU_CONTACT_EMAIL']

# The API key needed to access data from mobile apps
JUMU_MOBILE_API_KEY = ENV['JUMU_MOBILE_API_KEY']
