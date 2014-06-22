class ParkEntrance < ActiveRecord::Base
  belongs_to :park
  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  def to_geojson
    park_entrance = {}
    park_entrance["type"] = "Feature"
    park_entrance["id"] = id
    park_entrance["geometry"] = RGeo::GeoJSON.encode(coordinates)
    properties = {}
    properties["park_name"] = park.name
    properties["park_id"] = park.id
    properties["primary"] = primary.to_s
    park_entrance["properties"] = properties
    park_entrance
  end
end
