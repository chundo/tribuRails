class Report < ApplicationRecord
    has_one_attached :image_a#, prefix: 'report'
    has_one_attached :image_b#, prefix: 'report'
end
