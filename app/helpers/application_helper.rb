module ApplicationHelper
  def full_title page_title
    base_title = It18n.t "base_title"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
