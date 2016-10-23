# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  birthdate  :date
#  phone      :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Participant do

  # ...

  describe "should update its performances when the birthdate is changed"

end
