class Contact
  include ActiveModel::Validations
  attr_accessor :id, :name, :email, :subject, :content
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,    :presence => true
  validates :email,   :presence => true,
                      :format => { :with => email_regex }
  validates :subject, :presence => true
  validates :content, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
    @attributes = attributes
  end
 
  def read_attribute_for_validation(key)
    @attributes[key]
  end
  
  def to_key
  end
  
  def save
    if self.valid?
      ContactMailer.contact_message(self).deliver
      return true
    else
      return false
    end
  end
end
