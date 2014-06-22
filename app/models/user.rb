class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :image_tags, foreign_key: :uploader_id
  has_many :pins
end
