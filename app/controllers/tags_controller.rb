class TagsController < ApplicationController
  before_action :set_tag, only: %i[ destroy ]  
  def index 
    @tags = Tag.all.order(course_tags_count: :desc)
    authorize @tags
  end
  
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag
    else
      render json: {errors: @tag.errors.full_messages}
    end
  end
  
  def destroy
    authorize @tag
    if @tag.destroy
      respond_to do |format|
        format.html { redirect_to tags_path, notice: "Tag was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
  
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end
end 