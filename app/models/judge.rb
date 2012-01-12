class Judge < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :city, :country_id, :competition_ids
  
  belongs_to :country
  has_and_belongs_to_many :competitions
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def inverse_full_name
    "#{last_name}, #{first_name}"
  end
end
