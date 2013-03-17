module Siblings
  module Services
    module Foursquare
  
      AUTH_TOKEN = 'YEROB0YJD5X0AS1QY2FUKWVNMIAHBWPM425SIVODKHT1UHQE'
      ENDPOINT = 'https://api.foursquare.com/v2'
  
      def checkins(limit = 5)
        r = HTTParty.get checkins_url
        r['response']['checkins']['items']
      end
  
      def search(lat, lon, limit = nil, intent = nil) 
        r = HTTParty.get search_url(lat, lon, limit, intent)
      end
  
      def nearby(limit = nil, intent = nil)
        search(current_location.lat, current_location.lon, limit, intent)
      end
    
      def latest_checkin
        checkins.first
      end
  
      def latest_venue
        latest_checkin['venue']
      end
  
      def checkin!
        checkin(latest_venue) unless @latest_venue_id == latest_venue['id']
        @latest_venue_id = latest_venue['id']
        @timer.reset
      end

      def checkin(venue)

        lat = venue['location']['lat']
        lon = venue['location']['lng']
        loc = Location.new(lat,lon)

        move_to(loc, {:checkin => true, :venue => venue})

      end
  
      private
  
      def search_url(lat,lon, limit = 10, intent = 'checkin')
        ll = "#{lat},#{lon}"
        "#{ENDPOINT}/venues/search?ll=#{ll}&limit=#{limit}&intent=#{intent}"
      end
  
      def checkins_url(limit = 5)
        "#{ENDPOINT}/users/self/checkins?limit=#{limit}&oauth_token=#{AUTH_TOKEN}"
      end
  
    end
  end
end