class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workouts
  has_many :exercises, dependent: :restrict_with_error
end
