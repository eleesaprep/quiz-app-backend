class Api::V1::EnrollmentsController < ApplicationController
  before_action :require_login
  # GET /payments
  def index
    @enrollments = Enrollment.all
    render json: @enrollments
  end

  # GET /rentals/:id
  def show
    @enrollment = Enrollment.find(params[:id])
    render json: @enrollment
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      render json: @enrollment, status: :created
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @enrollment = Enrollment.find(params[:id])
      @enrollment.destroy
      render json: { message: 'Enrollment deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this enrollment' }
    end
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:enrollment_date, :status, :user_id, :course_id)
  end
end
