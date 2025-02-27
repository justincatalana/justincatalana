module ApplicationHelper
  def nav_link(title, path)
    if current_page?(path)
      content_tag(:span, title, class: "font-bold text-gray-800")
    else
      link_to(title, path, class: "text-indigo-600 hover:underline", data: { turbo_frame: "content" })
    end
  end
end
