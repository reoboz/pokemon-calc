class Ability < ApplicationRecord

  default_scope -> { where(amount: 1..Float::INFINITY) }
end
