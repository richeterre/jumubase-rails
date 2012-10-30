class ActiveRecord::Base
  attr_accessible # Make all attributes non-accessible by default
  attr_accessor :accessible

  private

    def mass_assignment_authorizer(role = :default)
      if accessible == :all
        # Allow access to all attributes that aren't explicitly protected
        self.class.protected_attributes
      else
        super(role) + (accessible || [])
      end
    end
end
