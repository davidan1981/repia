require 'test_helper'

class RepiaUniqueModelTest < ActiveSupport::TestCase

  class UniqueModel < ActiveRecord::Base
    include Repia::UUIDModel
  end

  test "UniqueModel gets assigned a UUID at creation" do
    obj = UniqueModel.new()
    obj.save()
    assert_not_nil obj.uuid
  end

end
