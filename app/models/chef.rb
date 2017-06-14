class Chef < ApplicationRecord
  before_save   { self.email = email.downcase }
  validates     :chefname, presence: true, length: {minimum: 5, maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates     :email, presence: :true, length: {minimum: 6, maximum: 255},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  has_many      :recipes, dependent: :destroy
  has_secure_password
  validates     :password, presence: true, length: {minimum: 5}, allow_nil: true
  # the has_secure_password enforces that it must have a password. The allow_nil exception allows a submit not to contain this data. (e.g. in the edit form)

  has_many      :comments, dependent: :destroy
  
  default_scope -> {order(updated_at: :desc)}
  
  has_many      :messages, dependent: :destroy
  
end