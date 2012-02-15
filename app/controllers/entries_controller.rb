# -*- encoding : utf-8 -*-
class EntriesController < ApplicationController
  
  # Presents the signup form for participants
  def new
    @entry = Entry.new
    # Build initial resources for form
    1.times do
      appearance = @entry.appearances.build
      appearance.build_participant
    end
    1.times do
      piece = @entry.pieces.build
      piece.build_composer
    end
    @title = "Anmeldung"
  end
  
  # Creates a new entry upon signup form submission
  def create
    # Create empty entry
    @entry = Entry.new
    # Make all attributes accessible to admins
    @entry.accessible = :all if admin?
    @entry.attributes = params[:entry]
    
    begin
      # Get edit code, repeat if already existent
      code = new_edit_code
    end while Entry.where(:edit_code => code).exists?
    
    @entry[:edit_code] = code
    
    if @entry.save
      # Send out confirmation emails with edit code
      @entry.participants.each do |p|
        ParticipantMailer.signup_confirmation(p, @entry).deliver
      end
      
      flash[:success] = "Die Anmeldung wurde erfolgreich gespeichert."
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  # Finds an existing signup form by edit code and redirects to it
  def search
    unless params[:edit_code].nil?
      existing = Entry.current.find_by_edit_code(params[:edit_code])
      if existing
        redirect_to edit_entry_path(existing, :edit_code => params[:edit_code])
      else
        flash.now[:error] = "Keine Anmeldung unter diesem Änderungscode gefunden."
      end
    end
    @title = "Nach Anmeldung suchen"
  end
  
  # Presents an existing signup form for editing
  def edit
    @entry = Entry.current.find(params[:id])
    unless admin? || @entry[:edit_code] == params[:edit_code]
      flash[:error] = "Bitte gib einen gültigen Änderungscode ein."
      redirect_to signup_search_path
    end
    @title = "Anmeldung bearbeiten"
  end
  
  # Stores changes made to an existing signup form
  def update
    @entry = Entry.current.find(params[:id])
    # Make all attributes accessible to admins
    @entry.accessible = :all if admin?
    if @entry.update_attributes(params[:entry])
      flash[:success] = "Die Anmeldung wurde erfolgreich aktualisiert."
      redirect_to signup_search_path
      # redirect_to entries_path
    else
      @title = "Anmeldung bearbeiten"
      render 'edit'
    end
  end
  
  private
    
    # Returns an edit code for signup form editing
    def new_edit_code
      # Generates a random string of seven lowercase letters and numbers
      [('a'..'z'), (0..9)].map{ |i| i.to_a }.flatten.shuffle[0..6].join
    end
end