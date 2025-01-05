class JobsController < ApplicationController
  before_action :set_job, only: %i[ show ]

  #def index
  #  @jobs = Job.all
  #end

  def create
    service = Jobs::Create.call(params[:parentable_type], @current_user, params[:file_txt])
    job = service.result

    render turbo_stream: turbo_stream.replace("job-modal", partial: "jobs/modal_body", locals: { job: job })
  end

  def show
    render json: @job
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.permit(:id, :file_txt, :parentable_type)
  end
end
