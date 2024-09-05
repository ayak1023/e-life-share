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

  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE ? OR body LIKE ?", "#{word}", "#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE ? OR body LIKE ?", "#{word}%", "#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE ? OR body LIKE ?", "%#{word}", "%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE ? OR body LIKE ?", "%#{word}%", "%#{word}%")
    else
      @post = Post.all
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
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
