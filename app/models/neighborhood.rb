class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    self.listings.collect do |list| # collects listing if res. dates don't conflict
      list if list.reservations.all? {|res| listing_available(res, checkin, checkout)}
    end
  end

  def self.highest_ratio_res_to_listings 
    hood_ratios = self.all.collect do |hood|  # loops through all citys
      {hood: hood, ratio: res_count(hood)/list_count(hood)} if hood.listings && !hood.listings.empty?  # makes array of key value pairs, city and ratio
    end
    hood_ratios.delete(nil)
    hood_ratios.max_by{|c| c[:ratio]}[:hood] # finds the highest ratio and returns instance of city
  end

  def self.most_res # find city with most reservations
    self.all.collect {|hood|  # loops through all citys
    {hood: hood, res_count: res_count(hood)} # makes array of key value pairs, city and res_count
    }.max_by{|c| c[:res_count]}[:hood]  # finds the highest ratio and returns instance of city
  end

  private

  def self.res_count(hood)
    count = 0 # sets counter for reservations
    hood.listings.each {|l| l.reservations.each {|r| count += 1}} if !hood.listings.empty? # counts reservations
    count
  end

  def self.list_count(hood)
    hood.listings.count.to_f
  end

  def listing_available(res, checkin, checkout) # set range of res, check if range includes checkin or checkout
    range = res.checkin..res.checkout
    !range.include?(Date.parse checkin) && !range.include?(Date.parse checkout)
  end
end
