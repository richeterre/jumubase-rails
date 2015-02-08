class ContactMailer < ActionMailer::Base
  default :to => JUMU_CONTACT_EMAIL

  def contact_message(contact)
    @contact = contact
    mail(:from => "#{contact.name} <#{contact.email}>", :subject => contact.subject)
  end
end
