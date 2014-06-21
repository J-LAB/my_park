class ImageTagger

  def self.tag_image(params)
    file_path = write_to_tmp_location(params["photo"])
    create_image_tag(file_path)
  end

  def self.create_image_tag(file_path)
    exif = EXIFR::JPEG.new(file_path)
    ImageTag.create(
      coordinates: "POINT(#{exif.gps.latitude} #{exif.gps.longitude})"
    )
  end

  def self.write_to_tmp_location(uploaded_io)
    file_name = uploaded_io.original_filename
    file_path = Rails.root.join('public', 'photos', file_name)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    return file_path.to_s
  end
end
