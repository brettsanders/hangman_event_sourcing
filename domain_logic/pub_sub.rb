class PubSub
  attr_reader :subscribers, :view

  def initialize(subscribers:)
    @subscribers = subscribers
  end

  def publish(event)
    subscribers.each {|subscriber|
      subscriber.call(event)
    }
  end
end