class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : 3
    offset = params[:offset].to_i >= 0 ? params[:offset].to_i : 0

    @posts = Post.joins(:user)
                 .order(created_at: :desc)
                 .select("posts.*, users.name AS user_name,
                          (
                            SELECT json_agg(subquery)
                            FROM (
                              SELECT *, users.name AS user_name
                              FROM comments c
                              LEFT JOIN users ON c.user_id = users.id
                              WHERE c.post_id = posts.id
                              ORDER BY c.created_at DESC
                              LIMIT 5
                            ) subquery
                          ) AS comments_array,
                          COUNT(*) OVER() AS total_posts")
                  .limit(limit)
                  .offset(offset)
  end

  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def import
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = @current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path(postIdsActionNow: @post.id), notice: "Post criado com sucesso!" }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_path(postIdsActionNow: @post.id), notice: "Post editado com sucesso!" }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post excluído com sucesso!" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
