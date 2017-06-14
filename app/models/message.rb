class Message < ApplicationRecord
  
  validates   :content, presence: true, length: {minimum: 5, maximum: 255}
  validates   :chef_id, presence: true
  
  belongs_to  :chef
  
  # This is useful where you want to do a restrcition at the class level (e.g. don't give me everything)
  def self.most_recent
    order(:created_at).last(20)
  end
#  default_scope -> {order(created_at: :asc)}
  
end