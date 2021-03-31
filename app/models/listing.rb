class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_create :change_host_status
  after_destroy :change_host_status

  def average_review_rating
    reviews = self.reservations.collect{|res| res.review}
    numbers = reviews.collect{|rev| rev.rating.to_f}
    numbers.sum/numbers.size 
  end

  private

  def change_host_status
    if has_no_listings?
      self.host.host = false
    else
      self.host.host = true
    end
    self.host.save
  end
  def has_no_listings?
    #if the listing's users' listings array is empty
    self.host.listings.empty?
  end
end
