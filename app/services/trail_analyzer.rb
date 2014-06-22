require 'net/http'
class TrailAnalyzer

  def self.get_el(string)
    url = "http://maps.googleapis.com/maps/api/elevation"
    path = "http://maps.googleapis.com/maps/api/elevation/json?locations=#{string}"
    uri = URI.parse(url)
    r = Net::HTTP::Get.new(path)
    response = Net::HTTP.new(uri.host, uri.port).request(r)
    return [] if response.code != 200
    json = JSON.parse(response.body)
    json["results"]
  end

  def self.analyze!
    # start_point = Pin.create(coordinates: 'POINT(' + params['startLon'].to_s + ' ' + params['startLat']+')')
    # end_point = Pin.create(coordinates: 'POINT(' + params['endLon'].to_s + ' ' + params['endLat']+')')
    connection = ActiveRecord::Base.establish_connection(
                :adapter => "postgis",
                :database => "my_park_development"
    )
    Trail.where(climb: nil).each do |t|
      next unless t.geospatial_data.geometry_type == RGeo::Feature::LineString
      sql = "SELECT ST_NPoints(ST_GeomFromText('" + t.geospatial_data.as_text + "'))"
      result = connection.connection.execute(sql).first.values.first

      i = 1
      array = []
      while i <= result.to_i 
        sql = "SELECT ST_AsText(ST_PointN(ST_GeomFromText('" + t.geospatial_data.as_text + "'), " + i.to_s + "))"
        answer = connection.connection.execute(sql).first.values.first
        next if answer.nil?
        array << answer
        if result.to_i < 11
          i += 1
        elsif result.to_i < 21
          i += 2
        else
          i += 3
        end
      end

      formatted_string = array.inject("") do |m, x|
        pin = Pin.new(coordinates: x)
        if m.length == 0
          m = "#{pin.coordinates.lat},#{pin.coordinates.lon}"
        else
          m = m + "|#{pin.coordinates.lat},#{pin.coordinates.lon}"
        end
        m
      end
      elevation_data = get_el(formatted_string)
      el_array = elevation_data.map { |x| x["elevation"] }
      t.climb = calculate_climb(el_array)
      t.descent = calculate_descent(el_array)
      t.save
    end
  end


  def self.calculate_climb(array)
    climb = 0
    prev_el = nil
    array.each do |el|
      prev_el ||= el
      if el > prev_el
        climb += el - prev_el
      end
      prev_el = el
    end
    return climb
  end
  def self.calculate_descent(array)
    descent = 0
    prev_el = nil
    array.each do |el|
      prev_el ||= el
      if el < prev_el
        descent += prev_el - el
      end
      prev_el = el
    end
    return descent
  end

    # Trail.select("ST_Distance(geospatial_data, 'POINT(#{params['start_lat']} #{params['start_lon']})') < 15")
    #   .where("ST_Distance(geospatial_data, 'POINT(#{params['end_lat']} #{params['end_lon']})') < 15").
    # t = Trail.where("ST_Distance(geospatial_data::geography, ST_GeomFromText('"+ start_point.coordinates.as_text + "')::geography) < 250")
    #   .where("ST_Distance(geospatial_data::geography, ST_GeomFromText('"+ end_point.coordinates.as_text + "')::geography) < 250")
    # p t.count
    # t = Trail.find(1768)
    # sql = "SELECT ST_Distance(ST_GeomFromText('" + t.geospatial_data.as_text + "')::geography, ST_GeomFromText('" + start_point.coordinates.as_text + "')::geography)"
    # distance = connection.connection.execute(sql).first.values.first
    # p "DISTANCE: #{distance}"
    # sql = "SELECT ST_Distance(ST_GeomFromText('" + start_point.coordinates.as_text + "')::geography, ST_GeomFromText('" + end_point.coordinates.as_text + "')::geography)"
    # distance = connection.connection.execute(sql).first.values.first
    # p "DISTANCE: #{distance}"
    # p "Distance: #{start_point.coordinates.distance(end_point.coordinates)}"
    # sql1 = "SELECT ST_LineLocatePoint('" + t.geospatial_data.as_text + "', '" + start_point + "')"
    # actual_start = connection.connection.execute(sql1).first.values.first
    # p actual_start
    # sql2 = "SELECT ST_LineLocatePoint('" + t.geospatial_data.as_text + "', '" + end_point + "')"
    # actual_end = connection.connection.execute(sql2).first.values.first
    # p actual_end
    # sql3 = "SELECT ST_AsText(ST_LineSubstring(ST_GeomFromText('" + t.geospatial_data.as_text + "'), " + actual_start + ", " + actual_end + "))"
    # result = connection.connection.execute(sql3).first.values.first
    # p result
end
