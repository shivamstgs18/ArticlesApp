class Article < ApplicationRecord

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  
  validates :title, presence: true, length: {minimum: 6, maximum: 100}
  validates :description, presence: true, length: {minimum: 10, maximum: 1000}

  def revenue
    # Calculate revenue based on the number of views and likes of the article.
    # For simplicity, let's assume each view and like generate $0.50 in revenue.

    views_revenue = views * 0.50
    likes_revenue = likes * 0.50

    total_revenue = views_revenue + likes_revenue

    # You can add more factors to calculate revenue based on other metrics as needed.

    total_revenue
  end

  def increment_views
    self.views ||= 0
    self.views += 1
    save
  end

  def popularity_score
    likes_count + views_count + comments_count
  end

  def total_likes
    likes.try(:count) || 0
  end

  before_save :calculate_reading_time

  private

  def calculate_reading_time
    # Calculate reading time using an average reading speed, e.g., 200 words per minute
    words_per_minute = 100
    word_count = description.split.size
    self.reading_time = (word_count.to_f / words_per_minute).ceil
  end
end