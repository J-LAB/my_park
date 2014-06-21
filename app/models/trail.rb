class Trail < ActiveRecord::Base
   set_rgeo_factory_for_column(:geospatial_data, RGeo::Geographic.spherical_factory(:srid => 4326))
end
