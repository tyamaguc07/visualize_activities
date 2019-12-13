module VisualizeActivities
  class PullRequest
    class Review
      def initialize(comment_set)
        @comment_set = comment_set
      end

      private

      attr_reader :comment_set
    end
  end
end
