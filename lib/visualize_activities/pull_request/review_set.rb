module VisualizeActivities
  class PullRequest
    class ReviewSet
      def initialize(reviews)
        @reviews = reviews
      end

      def exists?
        reviews.present?
      end

      def not_exists?
        !exists?
      end

      private

      attr_reader :reviews
    end
  end
end
