class ParticipantMailer < ActionMailer::Base
  default :from => "anmeldung@jumu-nordost.eu"
  
  def signup_confirmation(participant, performance)
    @participant = participant
    @performance = performance
    mail(:to => "#{participant.first_name} #{participant.last_name} <#{participant.email}>",
        :subject => "JuMu-Anmeldung in der Kategorie \"#{performance.category.name}\"")
  end
end
