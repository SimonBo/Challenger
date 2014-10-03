class Challenge < ActiveRecord::Base
  
  has_many :dares
  has_many :users, through: :dares, source: :challenges

  validates :name, presence: true, uniqueness: true, length: { in: 2..50 }
  validates :description, presence: true, length: { in: 2..500 }

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
