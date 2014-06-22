class TrailAnalyzer
  def self.analyze!(params)
    trail_segment = find_trail_segment(params)
  end

  def self.find_trail_segment(params)
    start_point = "POINT(#{params['startLat']} #{params['startLon']})"
    end_point = "POINT(#{params['endLat']} #{params['endLon']})"
    connection = ActiveRecord::Base.establish_connection(
                :adapter => "postgis",
                :database => "my_park_development"
    )

    # Trail.select("ST_Distance(geospatial_data, 'POINT(#{params['start_lat']} #{params['start_lon']})') < 15")
    #   .where("ST_Distance(geospatial_data, 'POINT(#{params['end_lat']} #{params['end_lon']})') < 15").
    t = Trail.order("ST_Distance(geospatial_data, '#{start_point}')")


    sql = "ST_Line_Substring(#{t.first.geospatial_data}, ST_Line_Locate_Point(#{t.first.geospatial_data}, #{start_point}), ST_Line_Locate_Point(#{t.first.geospatial_data}, #{end_point})"
    result = connection.connection.execute(sql);
    require 'pry'; binding.pry
  end
end
