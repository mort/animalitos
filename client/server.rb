require 'rubygems'
require 'bundler/setup'
require 'em-websocket'
require 'em-hiredis'
 
EM.run do
  @channel = EM::Channel.new
 
  @redis = EM::Hiredis.connect
  
  c = 'animalitos:live'
  
  puts "subscribing to #{c}"
  
  @redis.subscribe(c)
  
  @redis.on(:message){|channel, message| 
    puts "redis -> #{channel}: #{message}"
    @channel.push message 
  }
 
  # Creates a websocket listener
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8081) do |ws|
    puts 'Establishing websocket'
    ws.onopen do
      puts 'client connected'
      puts 'subscribing to channel'
      sid = @channel.subscribe do |msg| 
        puts "sending: #{msg}"
        ws.send msg
      end
 
      ws.onmessage { |msg|
        @channel.push "<#{sid}>: #{msg}"
      }
 
      ws.onclose {
        @channel.unsubscribe(sid)
      }
    end
  end
end