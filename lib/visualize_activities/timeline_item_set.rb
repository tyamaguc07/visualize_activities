module VisualizeActivities
  class TimelineItemSet
    def initialize(timeline_items)
      @timeline_items = timeline_items
    end

    private

    attr_reader :timeline_items
  end
end
