class ParkArea < ActiveRecord::Base
  has_many :image_tags, as: :taggable
  belongs_to :park
  set_rgeo_factory_for_column(:boundary, RGeo::Geographic.spherical_factory(:srid => 4326))

  def to_geojson
    park_area = {}
    park_area["type"] = "Feature"
    park_area["id"] = id
    park_area["geometry"] = RGeo::GeoJSON.encode(boundary)
    properties = {}
    properties["acres"] = acres
    properties["park_name"] = park.name
    properties["park_id"] = park.id
    properties["name"] = name
    park_area["properties"] = properties
    park_area
  end
end
