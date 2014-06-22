class Park < ActiveRecord::Base
  has_many :image_tags, as: :taggable
  has_many :park_areas
  has_many :park_entrances
  has_many :trails
  belongs_to :district

  def to_geojson
    park = {}
    park["type"] = "Feature"
    park["id"] = id
    park["geometry"] = RGeo::GeoJSON.encode(boundary)
    properties = {}
    properties["name"] = name
    properties["trail_count"] = trails.count
    properties["entrance_count"] = park_entrances.count
    properties["acres"] = acres
    park["properties"] = properties
    park
  end

end
