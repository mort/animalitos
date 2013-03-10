class Streamer
  
  $redis = Redis.new
  
  def update(activity)

    # Pub/sub for realtime updates
    # channels_for(activity, 'live').each do |c| 
    #     $redis.publish(c, msg) 
    #   end
    #   
    #   # Timestamped Sorted Sets for timelines
    #   channels_for(activity, 'timeline').each do |c|
    #     $redis.zadd(c, Time.now.to_i, msg)
    #   end
      
  end
  
  def channels_for(sender, event_type, channel_type = 'live')

    c = "animalitos"
    klass = sender.class.to_s.downcase

    channels = []

    channels << [c, channel_type, 'world'].join(':')
    channels << [c, channel_type, event_type.to_s].join(":")
    channels << [c, channel_type, klass, sender.to_param].join(":")
    channels << [c, channel_type, klass, sender.to_param, event_type.to_s].join(":")
    
    channels
    
  end

end