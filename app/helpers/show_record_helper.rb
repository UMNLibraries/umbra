module ShowRecordHelper
  def img
    @document.fetch('object_ssi', false).to_s
  end

  def thumb_url
    @document.fetch('isShownAt_ssi', false)
  end

  def subjects
    @document.fetch('subject_ssim', false)
  end

  def rights
    @document.fetch('sourceResource_rights_ssi', false)
  end

  def data_provider
    @document.fetch('dataProvider_ssi', false)
  end

  def provider_name
    @document.fetch('provider_name_ssi', false)
  end
  def display_title
    @document.fetch('title_ssi', false)
  end

  def collection
    @document.fetch('sourceResource_collection_title_ssi', false)
  end

  def type
    @document.fetch('sourceResource_type_ssi', '')
  end

  def is_sound?
    type == 'sound'
  end

  def thumbnail
    (is_sound?) ? sound_icon : thumbnail_image
  end

  def thumbnail_image
    link_to image_tag(img, alt: display_title, style: 'margin-top:20px;', width: '200%'), thumb_url
  end

  def sound_icon
    link_to raw("<span alt=\"#{display_title}\" class=\"icon-search icon-headphones\"></span>"), thumb_url
  end

  def description
    @document.fetch('sourceResource_description_tesi', false)
  end

  def set_page_title!
    @page_title = t('blacklight.search.show.title', :document_title => document_show_html_title, :application_name => application_name).html_safe
  end
end