module GnsCore
  module ApplicationHelper
    # Status /list page
    def status_badge(status)
      status.present? ? "<span class=\'badge badge-#{status}\'>#{t('.' + status)}</span>".html_safe : ''
    end
    
    def display_active(active)
      if active == true
        "<span class=\'badge badge-active'>#{t('.active')}</span>".html_safe
      else
        "<span class=\'badge badge-inactive'>#{t('.inactive')}</span>".html_safe
      end
    end
    
    def badge_mark(status)
      "<div class=\"text-muted font-size-sm\"><span class=\"badge badge-mark border-#{status} mr-1\"></span> #{(status)}</div>".html_safe
    end
    
    def display_address(object)
      str = []
      str << object.address if object.address.present?
      str << object.district_name if object.district_name.present?
      str << object.state_name if object.state_name.present?
      str << object.country_name if object.country_name.present?
      return str.join(", ")
    end
    
    def creator_name(creator)
      creator.present? ? creator.name : '--'
    end
    
    def format_percentage(num)
      "%g" % ("%.2f" % num)
    end
  end
end
