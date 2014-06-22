class ParkArea < ActiveRecord::Base
  has_many :image_tags, as: :taggable
  belongs_to :park

  def to_geojson
    park_area = {}
    park_area["type"] = "Feature"
    park_area["id"] = id
    park_area["geometry"] = RGeo::GeoJSON.encode(boundary)
    properties = {}
    properties["acres"] = acres
    properties["park_name"] = park.name unless park.nil?
    properties["park_id"] = park.id unless park.nil?
    properties["name"] = name
    park_area["properties"] = properties
    park_area
  end
end
