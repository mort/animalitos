Message = Struct.new :from, :subject, :body, :created_at

class Inbox < Array

  attr_reader :owner

  include Observable
  
  def initialize(owner)

    @owner = owner
    add_observer "#{owner.class.to_s}InboxObserver".constantize.send(:new)

    super()
  end

  def <<(msg)
    
    raise "InvalidMessage" unless msg.is_a?(Message)
    
    changed
    notify_observers msg
    super
  end
  
  private
  
  def validate_msg(msg)
    raise "InvalidMessage" unless msg.is_a?(Message) && valid_sender?(from) && msg.has_key?(:from)  && msg.has_key?(:subject) && msg.has_key?(:body) && msg.has_key?(:created_at)
  end
  
  def valid_sender?(sender)
    sender.is_a? Animalito || sender.is_a? Player
  end

end


class InboxObserver 
  
  def update(msg)
    t = msg.subject.to_s
    send "on_#{t}", msg.body
  end
  
  
  def on_msg(msg)
    puts msg.inspect
  end
  
end


class PlayerInboxObserver < InboxObserver

  def on_luma_level(body)
    puts "Luma level #{body}"
  end
  
end


class AnimalitoInboxObserver < InboxObserver; end


