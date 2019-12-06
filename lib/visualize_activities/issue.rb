require "cgi"

module VisualizeActivities
  Issue = Struct.new(:author, :title, :body_html, :url, :created_at) do

    def to_markdown
      <<-"MARKDOWN"
### [#{title}](#{url})

<iframe srcdoc="#{escaped_body_html}">
</iframe>
      MARKDOWN
    end

    def escaped_body_html
      body_html.gsub('&', '&amp;').gsub('"','&quot;')
    end
  end
end
