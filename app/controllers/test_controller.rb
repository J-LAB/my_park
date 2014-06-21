class TestController < ApplicationController
  def index 

  end

  def tag_image
    ImageTagger.tag_image(params)
  end
end
