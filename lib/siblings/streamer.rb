module Siblings
  
  module Streamable

    class Streamer
  
      $redis = Redis.new
  
      def update(activity)

        # Pub/sub for realtime updates
          channels_for(activity, 'pubsub').each do |c| 
            $redis.publish(c, activity) 
          end
      
          # Timestamped Sorted Sets for timelines
          channels_for(activity, 'feed').each do |c|
            $redis.zadd(c, Time.now.to_i, activity)
          end
          
          Siblings.logger.info(activity)
          #fanout(activity)
      
      end
  
      def channels_for(act, channel_type)

        c = "animalitos"
    
        activity = act.to_s
                    
        actor_id = JSON.parse(activity)['actor']['id'].split(':')[2]
        verb = JSON.parse(activity)['verb']
        object_id = JSON.parse(activity)['object']['id'].split(':')[2] if JSON.parse(activity)['object']
        location_id = JSON.parse(activity)['location']['id'].split(':')[2] if JSON.parse(activity)['location']

        channels = []

        channels << [c, channel_type, 'all'].join(':')
        channels << [c, channel_type, 'verbs', verb, 'verb'].join(":")
        channels << [c, channel_type, 'actors', actor_id, 'id'].join(":")
        channels << [c, channel_type, 'objects', object_id, 'id'].join(":") if JSON.parse(activity)['object']
        channels << [c, channel_type, 'locations', location_id, 'geohash'].join(":") if JSON.parse(activity)['location']
    
        channels
    
      end

      def fanout(activity) 
        # Updates followers' timelines
        # actor.followers
        # location.followers
        # object.followers
        # target.followers
      end
      

    end
  end
end