module Foursquare
  
  AUTH_TOKEN = 'YEROB0YJD5X0AS1QY2FUKWVNMIAHBWPM425SIVODKHT1UHQE'
  
  def checkins(limit = 5)
    r = HTTParty.get "https://api.foursquare.com/v2/users/self/checkins?limit=#{limit}&oauth_token=#{AUTH_TOKEN}"
    r['response']['checkins']['items']
  end
  
  def latest_checkin
    checkins.first
  end
  
  def latest_venue
    latest_checkin['venue']
  end
  
end