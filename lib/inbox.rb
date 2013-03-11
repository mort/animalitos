class Inbox < Array

  attr_reader :owner

  include Observable
  
  def initialize(owner)

    @owner = owner
    add_observer InboxObserver.new

    super()
  end

  def <<(msg)
    
    raise "InvalidMessage" unless msg.is_a?(Hash) && msg.has_key?(:type) && msg.has_key?(:body) && msg.has_key?(:created_at)
    
    changed
    notify_observers msg
    super
  end

end

class InboxObserver
  
  def update(msg)

    t = msg[:type] || 'msg'
    send "on_#{t}", msg[:body]

  end
  
  def on_msg
  end
  
  def on_luma_level(body)
    puts "Luma level #{body}"
  end
  
end