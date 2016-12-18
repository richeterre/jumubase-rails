# == Schema Information
#
# Table name: appearances
#
#  id               :integer          not null, primary key
#  performance_id   :integer
#  participant_id   :integer
#  instrument_id    :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  points           :integer
#  participant_role :string(255)
#

# -*- encoding : utf-8 -*-
class Appearance < ActiveRecord::Base
  include JumuHelper

  # Attributes that are accessible to everyone (needed for signup)
  attr_accessible :performance_id, :participant_id, :instrument_id, :participant_role, :participant_attributes

  belongs_to :performance, touch: true
  belongs_to :participant
  belongs_to :instrument

  accepts_nested_attributes_for :participant

  # These do not currently play nicely with accept_nested_attributes
  # validates :performance_id,  presence: true
  # validates :participant_id,  presence: true

  validates :instrument_id, presence: true
  validates :participant_role,
    presence: true,
    inclusion: { in: JUMU_PARTICIPANT_ROLES }
  validates :points,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 25
    },
    unless: lambda { |a| a.points.nil? } # Skip if none submitted

  # Return appearances with given role
  def self.with_role(role)
    where(participant_role: role)
  end

  # Return appearances with no associated points
  def self.pointless
    where(points: nil)
  end

  # Order by role: soloists -> ensemblists -> accompanists
  def self.role_order
    order("participant_role DESC") # lucky us!
  end

  # Perform participant existence check upon saving
  def participant_attributes_with_existence_check=(attributes)
    if self.id == nil
      # This is a new appearance
      attributes[:id] = nil
    end

    if attributes[:id].nil?
      # This is a new participant

      begin
        given_birthdate = Date.new(
          attributes['birthdate(1i)'].to_i,
          attributes['birthdate(2i)'].to_i,
          attributes['birthdate(3i)'].to_i
        )
      rescue
        given_birthdate = nil
      end

      participant = Participant.find_by_first_name_and_last_name_and_birthdate(
          attributes[:first_name], attributes[:last_name], given_birthdate)

      self.participant = participant
      # TODO: Maybe update that participant's other data here with current values?
      self.participant_attributes_without_existence_check=(attributes) if participant.nil?
    else
      self.participant_attributes_without_existence_check=(attributes)
    end
  end

  alias_method_chain 'participant_attributes=', :existence_check

  # Helper methods

  # Returns whether the appearance is a solo
  def solo?
    self.participant_role == 'soloist'
  end

  # Returns whether the appearance is an accompaniment
  def accompaniment?
    self.participant_role == 'accompanist'
  end

  # Returns whether the appearance is part of an ensemble
  def ensemble?
    self.participant_role == 'ensemblist'
  end

  # Returns the solo appearance that is accompanied by this one
  def related_solo_appearance
    self.performance.appearances.with_role('soloist').first
  end

  # Returns the participant's age group
  def age_group
    # NOTE: This method may be called before saving, so database queries are a no-no!

    season = self.performance.contest.season

    if self.solo? || (self.accompaniment? && !self.performance.category.popular?)
      # Soloists and non-popular accompanists have their own age group
      calculate_age_group(self.participant.birthdate, season)
    elsif self.ensemble?
      # Ensemble players share an age group
      ensemble_appearances = self.performance.appearances.select(&:ensemble?)
      calculate_age_group(ensemble_appearances.map { |a| a.participant.birthdate }, season)
    else
      # Pop accompanists share an age group (excluding the soloist)
      accompanist_appearances = self.performance.appearances.select(&:accompaniment?)
      calculate_age_group(accompanist_appearances.map { |a| a.participant.birthdate }, season)
    end
  end

  # Returns the achieved prize's name, or nil if none
  def prize
    # Try to match points to a prize range for the contest round
    JUMU_PRIZE_POINT_RANGES[self.performance.contest.round - 1].each do |prize, point_range|
      if point_range.include?(self.points)
        return prize
      end
    end
    # Points not found in any prize range
    return nil
  end

  # Return the achieved predicate's name, or nil if none
  def predicate
    # Try to match points to a predicate range for the contest round
    JUMU_PREDICATE_POINT_RANGES[self.performance.contest.round - 1].each do |predicate, point_range|
      if point_range.include?(self.points)
        return predicate
      end
    end
    # Points not found in any predicate range
    return nil
  end

  # Returns the prize or predicate name, if any
  def prize_or_predicate
    if self.points.nil?
      return nil
    else
      return self.prize || self.predicate
    end
  end

  # Return whether the participant fulfills the necessary conditions for advancing
  def may_advance_to_next_round?
    case self.performance.contest.round
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
