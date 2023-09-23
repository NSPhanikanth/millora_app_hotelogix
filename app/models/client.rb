class Client < ApplicationRecord
	has_many :hotels
    has_many :room_types

    default_scope lambda { where(is_active: true) }
end
