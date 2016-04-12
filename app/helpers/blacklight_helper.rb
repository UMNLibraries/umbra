module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Use custom DocumentPresenter class instead of default Blacklight::DocumentPresenter
  def presenter_class
    Umbra::DocumentPresenter
  end
end
