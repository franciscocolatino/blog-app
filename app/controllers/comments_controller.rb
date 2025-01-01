class CommentsController < ApplicationController
  def index
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : 5
    offset = params[:offset].to_i >= 0 ? params[:offset].to_i : 0

    comments = Comment.select("comments.*, users.name AS user_name")
                      .left_joins(:user)
                      .where(post_id: params[:post_id])
                      .order(created_at: :desc)
                      .limit(limit)
                      .offset(offset)

    render turbo_stream: turbo_stream.append("comments-box-#{params[:post_id]}", partial: "comments/comment_lines", locals: { comments: comments, post_id: params[:post_id] })
  end

  def create
    comment = Comment.new(comment_params)
    comment.user_id = @current_user.id if @current_user
    comment.save!

    comments = Comment.select("comments.*, users.name AS user_name")
                      .left_joins(:user)
                      .where(post_id: comment.post_id)
                      .order(created_at: :desc)
                      .limit(5)

    render turbo_stream: turbo_stream.replace("comments-#{comment.post_id}", partial: "comments/dropdown", locals: { comments: comments, post_id: comment.post_id })
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
