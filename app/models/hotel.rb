class Hotel < ApplicationRecord
    has_many :rooms

    default_scope lambda { where(is_active: true) }
end
