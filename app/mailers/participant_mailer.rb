class ParticipantMailer < ActionMailer::Base
  default :from => "anmeldung@jumu-nordost.eu"
  
  def signup_confirmation(participant, entry)
    @participant = participant
    @entry = entry
    mail(:to => "#{participant.first_name} #{participant.last_name} <#{participant.email}>",
        :subject => "JuMu-Anmeldung in der Kategorie \"#{entry.category.name}\"")
  end
end
