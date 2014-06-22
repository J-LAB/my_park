class Pin < ActiveRecord::Base
  belongs_to :user

  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  def start?
    position == "start"
  end

  def end?
    position == "end"
  end

  def to_geojson
    tag = {}
    tag["type"] = "Feature"
    tag["id"] = id
    tag["geometry"] = RGeo::GeoJSON.encode(coordinates)
    properties = {}
    properties["position"] = position
    properties["uploader"] = user.username unless user.nil?
    tag["properties"] = properties
    tag
  end
end
