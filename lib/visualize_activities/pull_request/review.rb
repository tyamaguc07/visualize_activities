module VisualizeActivities
  class PullRequest
    class Review
      def initialize(comment_set)
        @comment_set = comment_set
      end

      def comments
        comment_set.comments
      end

      private

      attr_reader :comment_set
    end
  end
end
