class Test < ApplicationRecord
  belongs_to :category
  has_many :test_passing, dependent: :delete_all
  has_many :users, through: :test_passing
  belongs_to :author, class_name: 'User'
  has_many :questions, dependent: :destroy

  scope :by_level, ->(lev) { where(level: lev) }
  scope :easy, -> { by_level(0..1) }
  scope :moderate, -> { by_level(2..4) }
  scope :advance, -> { by_level(4..Float::INFINITY) }
  scope :find_by_category, ->(category) { Test.joins(:category).where('categories.title = ?', category) }
  scope :for_users, -> { where(published: true) }

  validates :title, presence: true, uniqueness: { scope: :level }
  validates :level, numericality: { other_than: 0 }
  validates :time_limit, presence: true
  validate :published, :check_question

  def self.find_order_by_category(category)
    Test.find_by_category(category).order('tests.title DESC').pluck(:title)
  end

  def check_question
    if published && !fullfilled?

      errors.add :fullfilled, :no_question_answers, message: I18n.t('.cannot_publish_no_question_or_answer')
      return false
    end
    true
  end

  def fullfilled?
    return false unless questions.present?

    return false unless Question.answers?(questions)

    true
  end
end
