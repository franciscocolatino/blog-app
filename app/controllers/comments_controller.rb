class CommentsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = @current_user.id if @current_user
    @comment.save!
  end

  def comment_params
    params.permit(:content, :post_id)
  end
end
