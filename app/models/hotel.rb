class Hotel < ApplicationRecord
    belongs_to :client
    has_many :room_types
    has_many :rooms

    default_scope lambda { where(is_active: true) }
end
