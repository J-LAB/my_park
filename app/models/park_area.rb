class ParkArea < ActiveRecord::Base
  has_many :image_tags, as: :taggable
  belongs_to :park
  set_rgeo_factory_for_column(:boundary, RGeo::Geographic.spherical_factory(:srid => 4326))
end
