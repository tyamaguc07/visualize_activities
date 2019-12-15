require 'forwardable'

module VisualizeActivities
  class PullRequest
    class CommentSet
      extend Forwardable
      def_delegators :@comments, :each, :map

      def initialize(comments)
        @comments = comments
      end

      def exists?
        comments.present?
      end

      def not_exists?
        !exists?
      end

      attr_reader :comments
    end
  end
end
