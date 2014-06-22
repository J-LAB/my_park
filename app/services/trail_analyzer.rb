class TrailAnalyzer
  def self.analyze!(params)
    trail_segment = find_trail_segment(params)
  end

  def self.find_trail_segment(params)
    start_point = Pin.create(coordinates: 'POINT(' + params['startLon'].to_s + ' ' + params['startLat']+')')
    end_point = Pin.create(coordinates: 'POINT(' + params['endLon'].to_s + ' ' + params['endLat']+')')
    connection = ActiveRecord::Base.establish_connection(
                :adapter => "postgis",
                :database => "my_park_development"
    )

    # Trail.select("ST_Distance(geospatial_data, 'POINT(#{params['start_lat']} #{params['start_lon']})') < 15")
    #   .where("ST_Distance(geospatial_data, 'POINT(#{params['end_lat']} #{params['end_lon']})') < 15").
    t = Trail.where("ST_Distance(geospatial_data::geography, ST_GeomFromText('"+ start_point.coordinates.as_text + "')::geography) < 250")
      .where("ST_Distance(geospatial_data::geography, ST_GeomFromText('"+ end_point.coordinates.as_text + "')::geography) < 250")
    p t.count
    t = Trail.find(1768)
    sql = "SELECT ST_Distance(ST_GeomFromText('" + t.geospatial_data.as_text + "')::geography, ST_GeomFromText('" + start_point.coordinates.as_text + "')::geography)"
    distance = connection.connection.execute(sql).first.values.first
    p "DISTANCE: #{distance}"
    sql = "SELECT ST_Distance(ST_GeomFromText('" + start_point.coordinates.as_text + "')::geography, ST_GeomFromText('" + end_point.coordinates.as_text + "')::geography)"
    distance = connection.connection.execute(sql).first.values.first
    p "DISTANCE: #{distance}"
    p "Distance: #{start_point.coordinates.distance(end_point.coordinates)}"
    sql1 = "SELECT ST_LineLocatePoint('" + t.geospatial_data.as_text + "', '" + start_point + "')"
    actual_start = connection.connection.execute(sql1).first.values.first
    p actual_start
    sql2 = "SELECT ST_LineLocatePoint('" + t.geospatial_data.as_text + "', '" + end_point + "')"
    actual_end = connection.connection.execute(sql2).first.values.first
    p actual_end
    sql3 = "SELECT ST_AsText(ST_LineSubstring(ST_GeomFromText('" + t.geospatial_data.as_text + "'), " + actual_start + ", " + actual_end + "))"
    result = connection.connection.execute(sql3).first.values.first
    p result
  end
end
