class Challenge < ActiveRecord::Base
  
  has_many :dares
  has_many :users, through: :dares

  validates :name, presence: true, uniqueness: true, length: { in: 2..50 }
  validates :description, presence: true, length: { in: 2..500 }

  def self.text_search(query)
    if query.present?
      where("name @@ :q or description @@ :q", q: query)
    else
      where(nil)
    end
  end
end
