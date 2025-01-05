class Imports::ProcessPosts
  prepend SimpleCommand

  def initialize(job_id, current_user_id, arguments)
    @job = Job.find(job_id)
    @current_user = User.find(current_user_id)
    @arguments = arguments
  rescue => e
    error_handling(:initialize_process_file, e.to_s)
  end

  def call
    @job.update_columns(status: Job::PROCESSING, progress: 50)

    posts = process_data(@job.file.download)

    post_ids = create_posts(posts)

    if errors.full_messages.empty?
      @job.update_columns(status: Job::DONE, progress: 100, content: { post_ids: post_ids })
    else
      update_error_job(errors.values)
    end
  end

  def process_data(file_content)
    posts = []
    current_post = {}

    file_content.each_line do |line|
      line.strip!

      next if line.start_with?("#") || line.empty?

      if line.start_with?("title:")
        posts << current_post if current_post[:title]

        current_post = { title: line.gsub("title:", "").strip, content: "" }
      elsif line.start_with?("content:")
        current_post[:content] = line.gsub("content:", "").strip
      else
        current_post[:content] += " #{line}" # Adiciona ao conteúdo
      end
    end

    posts << current_post if current_post[:title] # Salva o último post

    posts
  rescue => e
    error_handling(:process_data, e.to_s)
  end

  def create_posts(posts)
    post_ids = []

    ActiveRecord::Base.transaction do
      posts.each do |post_data|
        post = Post.create!(title: post_data[:title], user_id: @current_user.id,
                            content: post_data[:content])
        post_ids << post.id
      end
    end

    post_ids
  rescue => e
    error_handling(:create_posts, e.to_s)
    raise ActiveRecord::Rollback
  end

  private

  def update_error_job(error)
    return if @job.blank?

    @job.update_columns(
      job_errors: [error], status: Job::FAILURE, progress: 100
    )
  end

  def error_handling(name, error)
    errors.add(name, error)

    update_error_job(error)
  end
end
