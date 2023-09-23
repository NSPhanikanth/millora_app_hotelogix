class RoomType < ApplicationRecord
    belongs_to :client
    has_many :rooms

    default_scope lambda { where(is_active: true) }
end
