class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  
  validate :checkout_before_checkin
  validate :dif_checkin_checkout
  validate :checkin_and_checkout_available

  def duration
    dates = self.checkin..self.checkout
    duration = dates.count - 1 # subtract one for the checkout day
  end

  def total_price
    price = self.listing.price * duration
  end

  private

  def dif_checkin_checkout
    errors.add(:checkin_checkout, "must be different") if self.checkin == self.checkout
  end

  def checkout_before_checkin
    errors.add(:checkin, "must be before checkout date") if self.checkin && self.checkout && self.checkin > self.checkout
  end

  def checkin_and_checkout_available # create durations for each listing reservation, check in current listing checkin and out dates conflict
    self.listing.reservations.each do |res|
      range = res.checkin..res.checkout
      if range.include?(self.checkin) || range.include?(self.checkout)
        errors.add(:reservation, "unavailable for these times")
      end
    end
  end
end
