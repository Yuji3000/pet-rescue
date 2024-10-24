require "test_helper"
require "action_policy/test_helper"

class Organizations::AdoptablePetsControllerTest < ActionDispatch::IntegrationTest
  include ActionPolicy::TestHelper

  setup do
    @pet = create(:pet)
  end

  context "#index" do
    should "have authorized scope" do
      assert_have_authorized_scope(
        type: :active_record_relation, with: Organizations::AdoptablePetPolicy
      ) do
        get adoptable_pets_url
      end
    end

    should "assign only unadopted pets" do
      adopted_pet = create(:pet, :adopted)

      get adoptable_pets_url

      assert_response :success
      assert_equal 1, assigns[:pets].count
      assert assigns[:pets].pluck(:id).exclude?(adopted_pet.id)
    end
  end

  context "#show" do
    should "be authorized" do
      assert_authorized_to(:show?, @pet, with: Organizations::AdoptablePetPolicy) do
        get adoptable_pet_url(@pet)
      end
    end
  end
end
