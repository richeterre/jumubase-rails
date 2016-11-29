class ParticipantMailer < ActionMailer::Base
  default from: "anmeldung@jumu-nordost.eu"

  def signup_confirmation(participant, performance)
    @participant = participant
    @performance = performance
    @contest = performance.contest
    mail(to: named_email_adress(participant),
         subject: "Jumu-Anmeldung in der Kategorie \"#{performance.category.name}\"")
  end

  def welcome_advanced(participant, performance)
    @participant = participant
    @performance = performance
    mail(to: named_email_adress(participant),
         subject: "Weiterleitung zum #{performance.contest.round_name_and_year} in #{performance.contest.host.city}")
  end

  private

    def named_email_adress(participant)
      "#{participant.first_name} #{participant.last_name} <#{participant.email}>"
    end
end
