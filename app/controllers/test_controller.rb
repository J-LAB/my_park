class TestController < ApplicationController
  def index 
    @parks = Park.all.map(&:to_geojson)
    @trails = Trail.all.map(&:to_geojson)
    @park_areas = ParkArea.all.map(&:to_geojson)
  end

  def tag_image
    Tagger.create_image_tag(params)
  end

  def analyze
    TrailAnalyzer.analyze!(params)
  end

  def upload

  end

  def uploaded
    ShapefileImporter.import!(params)
  end
end
