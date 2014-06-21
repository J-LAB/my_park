class Tag < ActiveRecord::Base
  belongs_to :uploader, class_name: "User"
  belongs_to :taggable, polymorphic: true
  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))
end
