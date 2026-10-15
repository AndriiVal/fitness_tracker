# frozen_string_literal: true

class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_visible_exercise, only: :show
  before_action :set_owned_exercise, only: %i[edit update destroy]

  def index
    @exercises = Exercise.visible_to(current_user).order(:name)
  end

  def show; end

  def new
    @exercise = current_user.exercises.build
  end

  def create
    @exercise = current_user.exercises.build(exercise_params)
    if @exercise.save
      redirect_to exercises_path, notice: 'The exercise was created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @exercise.update(exercise_params)
      redirect_to exercises_path, notice: 'Exercise updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @exercise.destroy
      redirect_to exercises_path, notice: 'Exercise deleted successfully.'
    else
      redirect_to exercise_path(@exercise), alert: @exercise.errors.full_messages.to_sentence
    end
  end

  private

  def set_visible_exercise
    @exercise = Exercise.visible_to(current_user).find(params[:id])
  end

  def set_owned_exercise
    @exercise = current_user.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :description)
  end
end
