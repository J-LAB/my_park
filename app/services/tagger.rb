class Tagger

  def self.create_tag(params)
    Tag.create(
      coordinates: "POINT(#{params["latitude"]} #{params["longitude"]})",
      comments: params["comments"]
    )
  end

  def self.create_image_tag(params)
    file_path = write_to_tmp_location(params["photo"])
    exif = EXIFR::JPEG.new(file_path)
    Tag.create(
      coordinates: "POINT(#{exif.gps.latitude} #{exif.gps.longitude})"
      comments: params["comments"]
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
