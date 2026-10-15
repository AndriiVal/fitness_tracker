# frozen_string_literal: true

class TrainingSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_workout
  before_action :find_training_set, only: %i[edit update destroy]
  before_action :load_available_exercises, only: %i[new create edit update]

  def new
    @training_set = @workout.training_sets.build
  end

  def create
    @training_set = @workout.training_sets.build(set_params)
    if @training_set.save
      redirect_to @workout, notice: 'The set was created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @training_set.update(set_params)
      redirect_to @workout, notice: 'The set has been updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @training_set.destroy
    redirect_to @workout, notice: 'Set deleted successfully.'
  end

  private

  def set_params
    params.require(:training_set).permit(:exercise_id, :repetitions, :weight)
  end

  def find_workout
    @workout = current_user.workouts.find(params[:workout_id])
  end

  def find_training_set
    @training_set = @workout.training_sets.find(params[:id])
  end

  def load_available_exercises
    @available_exercises = Exercise.visible_to(current_user).order(:name)
  end
end
