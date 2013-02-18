class Announcer
  
  $redis = Redis.new
  
  def update(sender, msg, type = :untyped)

    # Pub/sub for realtime updates
    channels_for(sender, type, 'live').each do |c| 
      $redis.publish(c, msg) 
    end
    
    # Timestamped Sorted Sets for timelines
    channels_for(sender, type, 'timeline').each do |c|
      $redis.zadd(c, Time.now.to_i, msg)
    end
      
  end
  
  def channels_for(sender, type, channel_type = 'live')

    c = "animalitos"
    klass = sender.class.to_s.downcase

    channels = []

    channels << [c, channel_type, 'global'].join(':')
    channels << [c, channel_type, type.to_s].join(":")
    channels << [c, channel_type, klass, sender.to_param].join(":")
    channels << [c, channel_type, klass, sender.to_param, type.to_s].join(":")
    
    channels
    
  end

end