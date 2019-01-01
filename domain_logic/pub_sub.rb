class PubSub
  attr_reader :subscribers

  def initialize(subscribers:)
    @events = []
    @subscribers = subscribers
  end

  def publish(event)
    subscribers.each {|subscriber|
      subscriber.call(event)
    }
  end
end