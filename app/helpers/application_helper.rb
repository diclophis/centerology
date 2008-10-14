# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  def cloud_classes
    %w(css1 css2 css3 css4)
  end
end
