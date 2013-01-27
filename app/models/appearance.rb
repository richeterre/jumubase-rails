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
  include JumuHelper

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

  # Return appearances with given role
  def self.with_role(role_slug)
    joins(:role)
    .where(roles: { slug: role_slug })
  end

  # Return appearances with no associated points
  def self.pointless
    where(points: nil)
  end

  # Order by role: soloists -> accompanists -> ensemblists
  def self.role_order
    order(:role_id)
  end

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

  # Helper methods
  # (Role helpers needed in performance validation, so role may be nil then)

  # Returns whether the appearance is a solo
  def solo?
    self.role.try(:slug) == 'S'
  end

  # Returns whether the appearance is an accompaniment
  def accompaniment?
    self.role.try(:slug) == 'B'
  end

  # Returns whether the appearance is part of an ensemble
  def ensemble?
    self.role.try(:slug) == 'E'
  end

  # Returns the solo appearance that is accompanied by this one
  def related_solo_appearance
    self.performance.appearances.with_role('S').first
  end

  # Returns the participant's age group
  def age_group
    # NOTE: This method may be called before saving, so database queries are a no-no!

    if self.solo? || (self.accompaniment? && !self.performance.category.popular)
      # Soloists and classical accompanists have their own age group
      calculate_age_group self.participant.birthdate
    elsif self.ensemble?
      # Ensemble players share an age group
      calculate_age_group self.performance.appearances.map { |a| a.participant.birthdate }
    else
      # Pop accompanists share an age group (excluding the soloist)
      accompanist_appearances = self.performance.appearances.select(&:accompaniment?)
      calculate_age_group accompanist_appearances.map { |a| a.participant.birthdate }
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

  # Return whether the participant fulfills the necessary conditions for advancing
  def may_advance_to_next_round?
    case JUMU_ROUND
    when 1
      # Check for sufficient age
      return false if ["Ia", "Ib"].include?(self.age_group)
    when 2
      # Conditions for second round
      return false if ["Ia", "Ib", "II"].include?(self.age_group)
    end

    return (self.points && self.points >= 23) # Basic condition is 23 or more points
  end

  # Return whether the participant will advance to the next round
  def advances_to_next_round?
    # Needs to fulfill necessary (own points) and sufficient (performance points) conditions
    return self.may_advance_to_next_round? && self.performance.advances_to_next_round?
  end
end
