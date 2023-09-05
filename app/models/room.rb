class Room < ApplicationRecord
    belongs_to :room_type
    belongs_to :hotel

    default_scope lambda { where(is_active: true) }
end
