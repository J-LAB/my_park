class Trail < ActiveRecord::Base
  has_many :image_tags, as: :taggable
  belongs_to :park
  set_rgeo_factory_for_column(:geospatial_data, RGeo::Geographic.spherical_factory(:srid => 4326))

  def to_geojson
    trail = {}
    trail["type"] = "Feature"
    trail["id"] = id
    trail["geometry"] = RGeo::GeoJSON.encode(geospatial_data)
    properties = {}
    properties["length"] = length.to_s
    properties["name"] = name
    properties["climb"] = climb.to_f
    properties["park_name"] = park.name unless park.nil?
    properties["park_id"] = park.id unless park.nil?
    properties["material"] = material
    trail["properties"] = properties
    trail
  end
end
