require 'zip'
class ShapefileImporter

  def self.import!(params)
    uploaded_io = params["geospatial_data"]
    geom = handle_zipped_file(uploaded_io.tempfile)
    GeographicEntity.create(name: params["geographic_entity"]["name"], geospatial_data: geom)
  end

  def self.handle_zipped_file(file_path)
    Dir.mktmpdir do |dir|
      Zip::File.open(file_path) do |zip_file|
        zip_file.each do |entry|
          dest_file = File.join(dir, entry.name)
          entry.extract(dest_file)
        end
        return read_shapefile(File.join(dir, zip_file.glob('*.shp').first.name))
      end
    end
  end

  def self.write_to_tmp_location(uploaded_io)
    file_name = uploaded_io.original_filename
    file_path = Rails.root.join('public', 'uploads', file_name)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    return file_path
  end

  def self.read_shapefile(file_path)
    raise "Not a shapefile" unless File.extname(file_path) == ".shp"
    factory = RGeo::Geographic.spherical_factory(:srid => 4326)
    # factory = RGeo::Geographic.spherical_factory(:srid => 4269)
    p file_path
    RGeo::Shapefile::Reader.open(file_path, :factory => factory) do |file|
      file.each do |record|
        require 'pry'; binding.pry
        return record.geometry
      end
    end
  end

end
