module Seo
  class Basic
    def initialize(seo_obj, no_postfix)
      @_no_postfix = no_postfix
      if seo_obj
        @_title = seo_obj.title if seo_obj.respond_to? :title
        if seo_obj.respond_to?(:seo_title) && seo_obj.seo_title.present?
          @_title = seo_obj.seo_title
        end
        
        @_description = seo_obj.seo_descr if seo_obj.respond_to? :seo_descr
        
        @_keywords = seo_obj.seo_keywords if seo_obj.respond_to? :seo_keywords

        @_image = seo_obj.seo_image if seo_obj.respond_to? :seo_image
        
        if seo_obj.respond_to?(:no_title_postfix) && seo_obj.no_title_postfix == '1'
          @_no_postfix = true
        end
      end
    end

    def title
      answ = nil
      if @_title.present?
        answ = @_title
        # TODO SiteSetting
        # answ += " : " + SiteSetting.value_of('site_name') unless @_no_postfix
        answ += " : " + "Mayak" unless @_no_postfix
      else
        # TODO SiteSetting
        # answ = SiteSetting.value_of('site_name')
        answ = "Mayak"
      end
      answ
    end

    def description
      @_description
    end

    def keywords
      @_keywords
    end

    def image
      @_image
    end

    # author
    # reply_to

    # og:title
    # og:description
    # og:site_name
    # og:image

    # twitter:title
    # twitter:description
    # twitter:image
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Module for including in ActiveRecord model with acts_as_seo_carrier
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  module Carrier
    def self.included(base)
      base.store :seodata, accessors: [ :no_title_postfix,
                                        :seo_title,
                                        :seo_descr,
                                        :seo_keywords ], coder: JSON
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Formtastic inputs for seo_carrier object (for Active Admin)
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  module FormtasticSeoFieldset

    # params:
    #   f is Formtastic object with object of model which acts_as_seo_carrier
    #   attributes: hash
    #     hide_seo_title - boolean - true if you need to remove seo_title input
    #     hide_no_title_postfix - boolean - same for no_title_postfix input
    def self.build(f, attributes = {})
      f.inputs I18n.t('seo.seo_parameters') do
        unless attributes[:hide_seo_title]
          f.input :seo_title, hint: I18n.t('seo.seo_title_hint')
        end
        unless attributes[:hide_no_title_postfix]
          f.input :no_title_postfix, as: :boolean
        end
        f.input :seo_descr, as: :text, input_html: { rows: 2 }
        f.input :seo_keywords, as: :text, input_html: { rows: 2 }
      end
    end

  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ActiveRecord model function for including Seo::Carrier module
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
class << ActiveRecord::Base
  def acts_as_seo_carrier
    include Seo::Carrier
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ActiveAdmin component for show page, showing seo parameters
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
module ActiveAdmin
  module Views

    class SeoPanel < Panel
      builder_method :seo_panel_for

      # params:
      #   seo_carrier is object of model which acts_as_seo_carrier
      #   attributes: hash
      #     hide_seo_title - boolean - true if you need to remove seo_title row
      #     hide_no_title_postfix - boolean - same for no_title_postfix row
      def build(seo_carrier, attributes = {})
        super t('seo.seo_parameters'), {}
        
        attributes_table_for seo_carrier do
          unless attributes[:hide_seo_title]
            row :seo_title do
              seo_carrier.seo_title.present? ? seo_carrier.seo_title :  "<small style=\"color:#999\">#{t('seo.empty_seo_title_info')}</small>".html_safe
            end
          end
          unless attributes[:hide_no_title_postfix]
            row :no_title_postfix do
              seo_carrier.no_title_postfix == '1' ? t('yep') : t('nope')
            end
          end
          row :seo_descr
          row :seo_keywords
        end

      end

    end

  end
end
