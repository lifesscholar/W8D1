# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  sub_id     :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord

    validates :title, :author_id, :sub_id, presence: true

    belongs_to :author,
        class_name: :User,
        foreign_key: :author_id

    belongs_to :sub,
        class_name: :Sub,
        foreign_key: :sub_id
end
