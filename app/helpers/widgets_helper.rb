module WidgetsHelper

  # White list of availalble types of forms
  def search_form_type
    case @widget_params[:search_form_type]
    when 'bootstrap'
      'bootstrap'
    else
      'standard'
    end
  end

  def contributing_institution
    Sanitize.clean(@widget_params[:contributing_institution])
  end

  def submit_text
    text = Sanitize.clean(@widget_params[:submit_text])
    (text == 'none') ? '' : 'Search'
  end

  def html_syntax_highlight(html)
    CodeRay.scan(html, :html).div()
  end

end