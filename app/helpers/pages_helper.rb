module PagesHelper

  def active(path)
    (current_page?(path)) ? 'active' : nil
  end


  def nav_item(link_text, path)
    "<li role=\"presentation\" class=\"#{active(path)}\">#{link(link_text, path)}</li>"
  end

  def link(text, path)
    link = link_to path, :tabindex => '-1', :role => 'menuitem' do
      raw text
    end
  end

  def linked_image(path, img, alt, title)
    link_to image_tag(img, alt: alt, title: title), path
  end
end
