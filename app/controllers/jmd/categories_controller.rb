# -*- encoding : utf-8 -*-
class Jmd::CategoriesController < Jmd::BaseController

  load_and_authorize_resource # CanCan

  # index: @categories are fetched by CanCan

  def new
    # @category is built by CanCan
    @max_rounds = allowed_max_rounds
  end

  def create
    # @category is built by CanCan
    if @category.save
      flash[:success] = "Die Kategorie #{@category.name} wurde erstellt."
      redirect_to jmd_categories_path
    else
      @max_rounds = allowed_max_rounds
      render 'new'
    end
  end

  def show
    # @category is fetched by CanCan
  end

  def edit
    # @category is fetched by CanCan
    @max_rounds = allowed_max_rounds
  end

  def update
    # @category is fetched by CanCan
    if @category.update_attributes(params[:category])
      flash[:success] = "Die Kategorie #{@category.name} wurde erfolgreich geändert."
      redirect_to jmd_categories_path
    else
      @max_rounds = allowed_max_rounds
      render 'edit'
    end
  end

  def destroy
    # @category is fetched by CanCan
    @category.destroy
    flash[:success] = "Die Kategorie #{@category.name} wurde gelöscht."
    redirect_to jmd_categories_path
  end

  private

    def allowed_max_rounds
      return [1, 2, 3] # Each round is a potential max round for some category
    end
end
