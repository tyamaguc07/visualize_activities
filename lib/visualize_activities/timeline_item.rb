module VisualizeActivities
  module TimelineItem
    class Base
      attr_reader :username, :content, :created_at

      def initialize(username, content, created_at)
        @username = username
        @content = content
        @created_at = created_at
      end

      def active?
        false
      end

      def comment?
        false
      end

      def pull_request?
        false
      end

      def reference_issue?
        false
      end

      def to_markdown
      end
    end
  end
end

require 'visualize_activities/timeline_item/cross_referenced_event'
require 'visualize_activities/timeline_item/issue_comment'
