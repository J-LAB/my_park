class TestController < ApplicationController
  def index 

  end

  def tag_image
    Tagger.tag_image(params)
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
