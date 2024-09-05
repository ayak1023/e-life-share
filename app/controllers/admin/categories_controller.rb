class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy]
  layout 'admin'

  def index
    @categories = Category.all
    @new_category = Category.new
  end

  def create
    @new_category = Category.new(category_params)
    if @new_category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      @categories = Category.all
      render :index
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
