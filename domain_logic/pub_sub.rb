class PubSub
  attr_reader :subscribers, :view

  def initialize(subscribers:, view: [])
    @subscribers = subscribers
    @view = view
  end

  def publish(event)
    subscribers.each {|subscriber|
      subscriber.call(event)
    }
    view.each {|read_model|
      read_model.call(event)
    }
  end
end