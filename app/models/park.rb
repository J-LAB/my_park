class Park < ActiveRecord::Base
 set_rgeo_factory_for_column(:boundary, RGeo::Geographic.spherical_factory(:srid => 4326))
end
