# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

    validates :username, :session_token, :password_digest, presence: true
    validates :username, uniqueness: true 
    validates :password, length: { minimum: 6 }, allow_nil: true

    after_initialize :ensure_session_token

    attr_reader :password

    has_many :subs,
        class_name: :Sub,
        primary_key: :id,
        foreign_key: :moderator_id,
        dependent: :destroy,
        inverse_of: :moderator

    has_many :posts,
        class_name: :Post,
        foreign_key: :author_id,
        dependent: :destroy,
        inverse_of: :author

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil unless user && user.is_password?(password)
        return user
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def self.generate_session_token
        SecureRandom.urlsafe_base64(16)
    end

    private

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end
end
