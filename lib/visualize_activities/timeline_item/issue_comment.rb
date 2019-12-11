module VisualizeActivities
  module TimelineItem
    class IssueComment < Base
      def comment?
        true
      end

      def to_markdown
        <<-"MARKDOWN"
<details>
  <iframe srcdoc="#{escaped_content_html}" style="width: 100%" />
</details>
        MARKDOWN
      end

      private

      def escaped_content_html
        content.gsub('&', '&amp;').gsub('"','&quot;')
      end
    end
  end
end
