module VisualizeActivities
  module TimelineItem
    class CrossReferencedEvent < Base
      def active?
        pull_requeset?
      end

      def pull_requeset?
        content.include?("#ref-pullrequest-")
      end

      def reference_issue?
        content.include?("#ref-issue-")
      end

      def to_markdown
        content
      end
    end
  end
end
