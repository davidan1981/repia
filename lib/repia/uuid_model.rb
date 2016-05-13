
module Repia

  ##
  # This module is a mixin that allows the model to use UUIDs instead of
  # normal IDs. By including this module, the model class declares that the
  # primary key is called "uuid" and an UUID is generated right before
  # save(). You may assign an UUID prior to save, in which case, no new UUID
  # will be generated.
  #
  module UUIDModel

    ##
    # Triggered when this module is included.
    #
    def self.included(klass)
      klass.primary_key = "uuid"
      klass.before_create :generate_uuid
    end

    ##
    # Generates an UUID for the model object.
    #
    def generate_uuid()
      self.uuid = UUIDTools::UUID.timestamp_create().to_s if self.uuid.nil?
    end
  end
end
