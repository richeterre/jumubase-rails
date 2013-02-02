class ParticipantMailer < ActionMailer::Base
  default from: "anmeldung@jumu-nordost.eu"

  def signup_confirmation(participant, performance)
    @participant = participant
    @performance = performance
    mail(to: named_email_adress(participant),
         subject: "JuMu-Anmeldung in der Kategorie \"#{performance.category.name}\"")
  end

  def welcome_advanced(participant, performance)
    @participant = participant
    @performance = performance
    mail(to: named_email_adress(participant),
         subject: "Weiterleitung zum #{performance.competition.round.slug} \
                   #{performance.competition.year} \
                   in #{performance.competition.host.city}")
  end

  private

    def named_email_adress(participant)
      "#{participant.first_name} #{participant.last_name} <#{participant.email}>"
    end
end
