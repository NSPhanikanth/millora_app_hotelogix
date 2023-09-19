class Client < ApplicationRecord
	has_many :hotels

    default_scope lambda { where(is_active: true) }
end
