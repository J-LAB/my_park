class ParkArea < ActiveRecord::Base
  belongs_to :park
  set_rgeo_factory_for_column(:boundary, RGeo::Geographic.spherical_factory(:srid => 4326))
end
