class TrailAnalyzer
  def self.analyze!(params)
    trail_segment = find_trail_segment(params)
  end

  def self.find_trail_segment(params)
    start_point = Pin.create(
      position: "start",
      coordinates: "POINT(#{params['start_lat']} #{params['start_lon']})"
    )
    end_point = Pin.create(
      position: "end",
      coordinates: "POINT(#{params['end_lat']} #{params['end_lon']})"
    )
    connection = ActiveRecord::Base.establish_connection(
                :adapter => "postgis",
                :host => "localhost",
                :database => "my_park_development"
    )

    # Trail.select("ST_Distance(geospatial_data, 'POINT(#{params['start_lat']} #{params['start_lon']})') < 15")
    #   .where("ST_Distance(geospatial_data, 'POINT(#{params['end_lat']} #{params['end_lon']})') < 15").
    t = Trail.order("ST_Distance(geospatial_data, 'POINT(#{params['end_lat']} #{params['end_lon']})')")
    require 'pry'; binding.pry

    # sql = ""
    # result = connection.connection.execute(sql);
    # p result
  end
end
