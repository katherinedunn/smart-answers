module EducationNavigationABTestable
  def education_navigation_ab_test
    @ab_test ||= GovukAbTesting::AbTest.new("educationnavigation")
  end

  def should_present_new_navigation_view?
    (education_navigation_variant.variant_b?) && new_navigation_enabled? && content_is_tagged_to_a_taxon?
  end

  def education_navigation_variant
    @education_navigation_variant ||= education_navigation_ab_test.requested_variant request
  end

  def new_navigation_enabled?
    ENV['ENABLE_NEW_NAVIGATION'] == 'yes'
  end

  def content_is_tagged_to_a_taxon?
    !content_item.dig("links", "taxons").blank?
  end

  def set_education_navigation_response_header
    education_navigation_variant.configure_response response
  end

  def self.included(base)
    base.helper_method :education_navigation_variant
    base.after_filter :set_education_navigation_response_header
  end
end
