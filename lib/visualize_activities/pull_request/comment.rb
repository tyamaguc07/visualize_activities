module VisualizeActivities
  class PullRequest
    class Comment
      def initialize(username, url, body_html, diff_hunk, created_at)
        @username = username
        @url = url
        @body_html = body_html
        @diff_hunk = diff_hunk
        @created_at = created_at
      end

      def to_markdown
        if diff_hunk.present?
          <<-"MARKDOWN"
#### [#{created_at}](#{url})

##### diff
<details>
```diff
#{diff_hunk}
```
</details>

<iframe srcdoc="#{escaped_content_html}" style="width: 100%" />
          MARKDOWN
        else
          <<-"MARKDOWN"
#### [#{created_at}](#{url})

<iframe srcdoc="#{escaped_content_html}" style="width: 100%" />
          MARKDOWN
        end
      end

      def escaped_content_html
        body_html.gsub('&', '&amp;').gsub('"','&quot;')
      end

      attr_reader :username, :url, :body_html, :diff_hunk, :created_at
    end
  end
end
