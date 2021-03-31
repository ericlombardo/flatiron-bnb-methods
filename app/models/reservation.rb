class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :cant_reserve_own_listing
  validate :listing_availability
  validate :checkin_not_same_as_checkout

  private

  def checkin_not_same_as_checkout
    if self.checkin && self.checkout && self.checkin == self.checkout
      errors.add(:reservation, "checking and checkout must not be the same")
    end
  end

  # def listing_availability
  #   # compare self.checkin to other checkin dates 
  #   dates = self.listing.reservations.collect{|r| r.checking}
  #   # if checkin date is the same or before existing reservations' checkout date for that listing, return true error out
  #   if dates.any?(r.checkin)
  #     errors.add(:checkin, "listing is not available")
  #   end
  # end

  def cant_reserve_own_listing
    if self.listing.host_id && self.guest_id && self.listing.host_id == self.guest_id
      errors.add(:reservation, "you can't reserve your own listing")
    end
  end

end
