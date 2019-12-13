module VisualizeActivities
  class PullRequest
    class CommentSet
      def initialize(comments)
        @comments = comments
      end

      private

      attr_reader :comments
    end
  end
end
