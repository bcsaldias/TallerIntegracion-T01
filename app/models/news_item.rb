class NewsItem < ApplicationRecord
  has_many :comments
  validates :lead, length: {maximum: 250}, allow_blank: true

  def count_comments
    Comment.where(:news_item_id => self.id).count
  end

end