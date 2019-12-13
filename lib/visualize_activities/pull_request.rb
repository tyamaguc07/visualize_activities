module VisualizeActivities
  class PullRequest
    def initialize(title, body_html, url, updated_at, review_set, comment_set)
      @title = title
      @body_html = body_html
      @url = url
      @review_set = review_set
      @comment_set = comment_set
      @updated_at = updated_at
    end

    def to_markdown
      <<-"MARKDOWN"
### [#{title}](#{url})

<iframe srcdoc="#{escaped_body_html}" style="width: 100%" />
      MARKDOWN
    end

    private

    def escaped_body_html
      body_html.gsub('&', '&amp;').gsub('"','&quot;')
    end

    attr_reader :title, :body_html, :url, :review_set, :comment_set, :updated_at
  end
end
