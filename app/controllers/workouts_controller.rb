# frozen_string_literal: true

class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: %i[show edit update destroy]

  def index
    @workouts = current_user.workouts.order(date: :desc)
  end

  def show; end

  def new
    @workout = current_user.workouts.build
  end

  def create
    @workout = current_user.workouts.build(workout_params)
    if @workout.save
      redirect_to @workout, notice: 'Training was created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @workout.update(workout_params)
      redirect_to @workout, notice: 'Training updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: 'Training deleted successfully.'
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:name, :date)
  end
end
