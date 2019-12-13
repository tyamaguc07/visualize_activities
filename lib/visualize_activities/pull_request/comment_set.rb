module VisualizeActivities
  class PullRequest
    class CommentSet
      def initialize(comments)
        @comments = comments
      end

      def exists?
        comments.present?
      end

      def not_exists?
        !exists?
      end

      private

      attr_reader :comments
    end
  end
end
