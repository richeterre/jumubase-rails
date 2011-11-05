class ContactMailer < ActionMailer::Base
  # By default, send message to whole core org.team
  default :to => JUMU_ORGMAILS
  
  def contact_message(contact)
    @contact = contact
    mail(:from => "#{contact.name} <#{contact.email}>", :subject => contact.subject)
  end
end