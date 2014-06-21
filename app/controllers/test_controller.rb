class TestController < ApplicationController
  def index 

  end

  def tag_image
    Tagger.tag_image(params)
  end
end
