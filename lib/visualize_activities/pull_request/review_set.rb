module VisualizeActivities
  class PullRequest
    class ReviewSet
      extend Forwardable
      def_delegators :@reviews, :each

      def initialize(reviews)
        @reviews = reviews
      end

      def exists?
        reviews.present?
      end

      def not_exists?
        !exists?
      end

      def comments
        reviews.map(&:comments).flatten
      end

      private

      attr_reader :reviews
    end
  end
end
