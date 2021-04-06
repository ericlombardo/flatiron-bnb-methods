class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  
  after_create :change_host_status
  before_destroy :remove_host_status?

  
  def average_review_rating # find all reviews for listing, return average
    ratings = self.reviews.pluck(:rating)
    ratings.sum(0.0)/ratings.count
  end

  private

  def change_host_status  # set host status to true after created
    list_host.host = true
    list_host.save
  end

  def remove_host_status? # check host for other listings, if none set host to false
    if list_host.listings.count == 1
      list_host.host = false
      list_host.save
    end
  end

  def list_host # returns current listing's host instance
    self.host
  end
end
