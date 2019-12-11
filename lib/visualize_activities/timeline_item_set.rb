module VisualizeActivities
  class TimelineItemSet
    def initialize(timeline_items)
      @timeline_items = timeline_items
    end

    def exists?
      timeline_items.present?
    end

    def not_exists?
      !exists?
    end

    def has_active_item?
      timeline_items.any?(&:active?)
    end

    def comments
      timeline_items.select(&:comment?)
    end

    private

    attr_reader :timeline_items
  end
end
