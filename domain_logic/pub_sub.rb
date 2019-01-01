class PubSub
  attr_reader :subscribers, :read_models

  def initialize(subscribers:, read_models: [])
    @subscribers = subscribers
    @read_models = read_models
  end

  def publish(event)
    subscribers.each {|subscriber|
      subscriber.call(event)
    }
    read_models.each {|read_model|
      read_model.call(event)
    }
  end
end