require 'test_helper'

class AbstractControllerTest < ActionController::TestCase
  setup do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("cocktail:french75")
    init_cocktails()
    @cocktail = @cocktails.first
  end
end

