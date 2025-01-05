class Jobs::Create
  prepend SimpleCommand

  def initialize(parentable_type, current_user, file)
    @parentable_type = parentable_type
    @file = file
    @current_user = current_user
    @service_job = "#{parentable_type.try(:camelize)}".constantize
  rescue => e
    error_handling(e.to_s)
  end

  def call
    return unless errors.full_messages.empty?

    create_job

    @service_job.perform_later(
      @job.id, @current_user.id, @arguments
    )

    @job
  rescue => e
    error_handling(e.to_s)
  end

  def create_job
    @job = Job.create!(
      progress: 10, author_id: @current_user.id,
      arguments: @arguments, parentable_type: @parentable_type,
      file: @file
    )
  rescue ActiveRecord::RecordInvalid => e
    error_handling(e.to_s)
  end

  def update_columns_job
    @job.update_columns(
      author_id: @current_user.id, job_errors: [],
      content: {}, arguments: {},
      status: Job::PENDING, progress: 0,
      origin_id: @origin_id, origin_type: @origin_type
    )
  end

  def update_error_job(error)
    return if @job.blank?

    @job.update_columns(
      job_errors: [error], status: Job::FAILURE, progress: 100
    )
  end

  def error_handling(error)
    errors.add(:error_handling, error)

    update_error_job(error)
  end
end
