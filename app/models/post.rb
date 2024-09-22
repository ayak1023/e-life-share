class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :category_posts, dependent: :destroy
  has_many :categories, through: :category_posts


  validates :title, presence: true
  validates :body, presence: true
  #validates :name, presence: true
  validate :category_limit


  scope :with_counts, -> {
    left_joins(:comments, :favorites)
    .select('posts.*, COUNT(comments.id) AS comments_count, COUNT(favorites.id) AS favorite_count')
    .group('posts.id')
  }

  scope :with_favorite_count, -> {
    select('posts.*, COUNT(favorites.id) AS favorite_count')
    .left_joins(:favorites)
    .group('posts.id')
  }

  scope :with_comments_count, -> {
    select('posts.*, COUNT(comments.id) AS comments_count')
    .left_joins(:comments)
    .group('posts.id')
  }


  def self.looks(search, word)
    where("posts.title LIKE ? OR posts.body LIKE ?", "%#{word}%", "%#{word}%")
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


  def self.with_counts
    select('posts.*, (SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id) AS comments_count,
            (SELECT COUNT(*) FROM favorites WHERE favorites.post_id = posts.id) AS favorite_count')
  end

  private

  def category_limit
    if category_ids.empty?
      errors.add(:category_ids, 'At least one category must be selected.')
    elsif category_ids.length > 3
      errors.add(:category_ids, 'You can select up to 3 categories.')
    end
  end

end
