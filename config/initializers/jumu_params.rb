# JuMu-related constants are defined here.
# Be sure to restart the server after changing any of these.

# The running number of the current competition season
JUMU_SEASON = 50

# The current competition (ending) year
JUMU_YEAR = 1963 + JUMU_SEASON

# The upcoming/ongoing round for signup, timetables, etc.
JUMU_ROUND = 2

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

# Possible age group values
JUMU_AGE_GROUPS = %w(Ia Ib II III IV V VI VII)

# Whether signup is possible for the above round
JUMU_SIGNUP_OPEN = true

# Whether timetables for the above round are public
JUMU_TIMETABLES_PUBLIC = true

# The 2nd round host
JUMU_HOST = "DS Moskau"

# The core organization team's mail addresses
JUMU_ORGMAILS = ["me@martinrichter.net",
                 "hery-christian.henry@deloitte.fi"]
