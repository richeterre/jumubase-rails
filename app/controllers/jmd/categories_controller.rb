# -*- encoding : utf-8 -*-
class Jmd::CategoriesController < Jmd::BaseController

  load_and_authorize_resource # CanCan

  # index: @categories are fetched by CanCan

  # new: @category is built by CanCan

  def create
    # @category is built by CanCan
    if @category.save
      flash[:success] = "Die Kategorie #{@category.name} wurde erstellt."
      redirect_to jmd_categories_path
    else
      render 'new'
    end
  end

  def show
    # @category is fetched by CanCan
  end

  def edit
    # @category is fetched by CanCan
  end

  def update
    # @category is fetched by CanCan
    if @category.update_attributes(params[:category])
      flash[:success] = "Die Kategorie #{@category.name} wurde erfolgreich geändert."
      redirect_to jmd_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    # @category is fetched by CanCan
    @category.destroy
    flash[:success] = "Die Kategorie #{@category.name} wurde gelöscht."
    redirect_to jmd_categories_path
  end
end
