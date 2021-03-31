class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation_id, presence: true

  validate :accepted_reservation_status
  validate :finished_checkout?
  
  private
  
  def accepted_reservation_status
    #self.reservation.status should be "accepted"
    #if the status is NOT "accepted", add error messages
    #validate method will check whether error array is empty
    if self.reservation && self.reservation.status != "accepted"
      errors.add(:status, "reservation must be accepted" )
    end
  end
  
  def finished_checkout?
    # self.created_at should be after self.reservation.checkout
    if self.created_at && self.created_at < self.reservation.checkout
      errors.add(:created_at, "review date must not be before reservation checkout")
    end
  end

end
