class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true
  
  validate :qualifications?

  private

  def qualifications? 
    if no_res_id  # checks for reservation_id
      errors.add(:reservation_id, "must be present to submit review")
    elsif checkout_not_passed # checks if checkout already past
      errors.add(:checkout, "must be in past to submit review")
    elsif status_pending  # checks if status accepted 
      errors.add(:status, "status must be accepted to submit review")
    end
  end

  def no_res_id
    !self.reservation_id
  end

  def checkout_not_passed
    self.reservation.checkout >= DateTime.now
  end

  def status_pending
    self.reservation.status == "pending"
  end
end
