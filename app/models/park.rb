class Park < ActiveRecord::Base
  has_many :image_tags, as: :taggable
  has_many :park_areas
  has_many :park_entrances, class_name: 'ParkEntrance'
  has_many :trails
  belongs_to :district

  set_rgeo_factory_for_column(:boundary, RGeo::Geographic.spherical_factory(:srid => 4326))
end
