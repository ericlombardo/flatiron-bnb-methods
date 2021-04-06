class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(checkin, checkout)
    self.listings.collect do |list| # collects listing if res. dates don't conflict
      list if list.reservations.all? {|res| listing_available(res, checkin, checkout)}
    end
  end

  def self.highest_ratio_res_to_listings 
    self.all.collect {|city|  # loops through all citys
    {city: city, ratio: res_count(city)/list_count(city)} # makes array of key value pairs, city and ratio
    }.max_by{|c| c[:ratio]}[:city] # finds the highest ratio and returns instance of city
  end

  def self.most_res # find city with most reservations
    self.all.collect {|city|  # loops through all citys
    {city: city, res_count: res_count(city)} # makes array of key value pairs, city and res_count
    }.max_by{|c| c[:res_count]}[:city]  # finds the highest ratio and returns instance of city
  end

  private

  
  def self.res_count(city)
    count = 0 # sets counter for reservations
    city.listings.each {|l| l.reservations.each {|r| count += 1}} # counts reservations
    count
  end

  def self.list_count(city)
    city.listings.count.to_f
  end
  
  def listing_available(res, checkin, checkout) # set range of res, check if range includes checkin or checkout
    range = res.checkin..res.checkout
    !range.include?(Date.parse checkin) && !range.include?(Date.parse checkout)
  end
  
end

