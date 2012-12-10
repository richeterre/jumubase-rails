# == Schema Information
#
# Table name: appearances
#
#  id             :integer          not null, primary key
#  performance_id :integer
#  participant_id :integer
#  instrument_id  :integer
#  role_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  points         :integer
#

# -*- encoding : utf-8 -*-
class Appearance < ActiveRecord::Base
  # Attributes that are accessible to everyone (needed for signup)
  attr_accessible :performance_id, :participant_id, :instrument_id, :role_id, :participant_attributes

  belongs_to :performance, touch: true
  belongs_to :participant
  belongs_to :instrument
  belongs_to :role

  accepts_nested_attributes_for :participant

  # These do not currently play nicely with accept_nested_attributes
  # validates :performance_id,  presence: true
  # validates :participant_id,  presence: true

  validates :instrument_id,   presence: true
  validates :role_id,         presence: true
  validates :points,          numericality: {
                                only_integer: true,
                                greater_than_or_equal_to: 0,
                                less_than_or_equal_to: 25
                              },
                              unless: lambda { |a| a.points.nil? } # Skip if none submitted

  # Filter by given role
  scope :with_role, lambda { |role| joins(:role).where('roles.slug' => role) }

  # Order by role: Soloists, accompanists, ensemblists
  scope :role_order, order(:role_id)

  # Order by stage time
  scope :stage_order, joins(:performance).order('entries.stage_time')

  # Perform participant existence check upon saving
  def participant_attributes_with_existence_check=(attributes)
    if self.id == nil
      attributes[:id] = nil
    end

    if attributes[:id].nil?
      # Birthdate check impossible because it's in three attributes, but country should be enough
      self.participant = Participant.find_by_first_name_and_last_name_and_country_id(
          attributes[:first_name], attributes[:last_name], attributes[:country_id])
      # TODO: Maybe update that participant's other data here with current values?
      self.participant_attributes_without_existence_check=(attributes) if participant.nil?
    else
      self.participant_attributes_without_existence_check=(attributes)
    end
  end

  alias_method_chain 'participant_attributes=', :existence_check

  # Returns whether the appearance is a solo
  def solo?
    self.role.slug == 'S'
  end

  # Returns whether the appearance is an accompaniment
  def accompaniment?
    self.role.slug == 'B'
  end

  # Returns whether the appearance is part of an ensemble
  def ensemble?
    self.role.slug == 'E'
  end

  # Returns the solo appearance that is accompanied by this one
  def related_solo_appearance
    self.performance.appearances.with_role('S').first # TODO: Validate that there is always just one, then remove this
  end

  # Returns the participant's age group (Ia–VII)
  def age_group
    if self.solo? || (self.accompaniment? && !self.performance.category.popular)
      # Soloists and classical accompanists have their own age group
      calculate_age_group self.participant.birthdate
    elsif self.ensemble?
      # Ensemble players share an age group
      calculate_age_group self.performance.participants.map(&:birthdate)
    else
      # Pop accompanists share an age group (excluding the soloist)
      calculate_age_group self.performance.accompanists.map(&:birthdate)
    end
  end

  # Returns the achieved prize's name
  def prize
    # Get prize point ranges for the appearance's competition round
    prize_point_ranges = JUMU_PRIZE_POINT_RANGES[self.performance.competition.round.level - 1]
    # Try to match points to a prize range
    prize_point_ranges.each do |prize, point_range|
      if point_range.include?(self.points)
        return prize
      end
    end
    # Points not found in any prize range
    return nil
  end

  # Returns whether the appearance will advance to the next competition stage
  def may_advance_to_next_round?
    # Basic condition is 23 or more points and that a next round exists
    return false if (!self.points || self.points < 23 || self.performance.competition.round.level == 3)

    # Accompanists don't advance if their soloist doesn't
    return false if (self.accompaniment? && !self.related_solo_appearance.may_advance_to_next_round?)

    # KiMu participants don't advance
    return false if (self.performance.category.name == "\"Kinder musizieren\"")

    # Check for other conditions
    case JUMU_ROUND
    when 1
      # Check for sufficient age
      !["Ia", "Ib"].include?(self.age_group)
    when 2
      # Conditions for second round
      (!["Ia", "Ib", "II"].include?(self.age_group) && !["Gitarre (Pop) solo", "E-Bass (Pop) solo", "Drum-Set (Pop) solo"].include?(self.performance.category.name))
      # TODO: Generalize pop category restrictions
    end
  end

  private

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
