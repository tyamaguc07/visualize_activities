module VisualizeActivities
  class TimelineItemSet
    def initialize(timeline_items)
      @timeline_items = timeline_items
    end

    def comments
      timeline_items.select(&:comment?)
    end

    private

    attr_reader :timeline_items
  end
end
