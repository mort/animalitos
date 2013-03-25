module Siblings
  module Services
    module Foursquare
  
      AUTH_TOKEN = 'YEROB0YJD5X0AS1QY2FUKWVNMIAHBWPM425SIVODKHT1UHQE'
      ENDPOINT = 'https://api.foursquare.com/v2'
  
      def checkins(limit = 1)
        r = HTTParty.get checkins_url(limit)
        r['response']['checkins']['items']
      end
  
      def venue_search(lat = nil, lon = nil, limit = 10, intent = 'checkin') 

        if current_location
          lat ||= current_location.lat 
          lon ||= current_location.lon 
        end
        
        raise "Invalid venue search" if (lat.nil? || lon.nil?)
        r = HTTParty.get venue_search_url(lat, lon, limit, intent)
      end
  
      def nearby(limit = nil, intent = nil)
        search(current_location.lat, current_location.lon, limit, intent)
      end
    
      def latest_checkin
        checkins.first
      end
  
      def latest_venue
        Services::Venue.new(latest_checkin['venue'])
      end
  
      def checkin(venue)

        lat = venue.location['lat']
        lon = venue.location['lng']
        loc = Location.new(lat,lon)

        @latest_venue_id = venue.id
        
        move_to(loc, {:checkin => true, :venue => venue})
        
      end
  
      def checkin!
        checkin(latest_venue) if (latest_venue && change_of_venue?(latest_venue))
        @timer.reset if @timer
      end
      
      def change_of_venue?(new_venue)
        @latest_venue_id.nil? || (@latest_venue_id != new_venue.id)
      end
  
  
      private
      
      def v
        Time.now.strftime('%Y%m%d')
      end
  
      def venue_search_url(lat, lon, limit = 10, intent = 'checkin')
        ll = "#{lat},#{lon}"
        "#{ENDPOINT}/venues/search?v=#{v}&ll=#{ll}&limit=#{limit}&intent=#{intent}&oauth_token=#{AUTH_TOKEN}"
      end
  
      def checkins_url(limit)
        "#{ENDPOINT}/users/self/checkins?v=#{v}&limit=#{limit}&oauth_token=#{AUTH_TOKEN}"
      end
  
    end
  end
end