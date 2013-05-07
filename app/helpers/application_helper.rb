module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Tnarik's App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def ga_track
    gabba = Gabba::Gabba.new("UA-40707807-1", "upped.me")
    gabba.referer(request.env['HTTP_REFERER']) if request
    gabba.ip(request.env["REMOTE_ADDR"]) if request
    gabba.page_view("title", "path")
    p gabba
    gabba.event("category_yy", "action_nn")
  end
end
