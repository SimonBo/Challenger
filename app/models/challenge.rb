class Challenge < ActiveRecord::Base
  
  has_many :dares
  has_many :users, through: :dares, source: :challenges

  validates :name, presence: true, uniqueness: true, length: { in: 5..100 }
  validates :description, presence: true, length: { in: 10..500 }

  include PgSearch
  pg_search_scope :search, against: [:name, :description],
                  using: {tsearch: {prefix: true, dictionary: "english" }}

  # after_save :create_dare

  def self.text_search(query)
    if query.present?
      search(query)
    else
      where(nil)
    end
  end

  def self.newest
    order(:created_at)
  end

  def self.sort_by_name
    order(:name)
  end

  def self.sort(choice)
    order(choice)
  end

  def rejected_by
    self.dares.where("status = ?", 'Rejected')
  end

  def accepted_by
    self.dares.where("status = ?", 'Accepted')
  end  

  def completed_by
    self.dares.where("status = ?", 'Completed')
  end 
end
