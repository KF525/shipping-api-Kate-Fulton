class Shipment < ActiveRecord::Base
  include ActiveMerchant::Shipping

  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :weight, presence: true

  def origin
    Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98118")
  end

  def destination
    Location.new(country: "US", state: state, city: city, postal_code: postal_code)
  end

  def packages
    Package.new(weight, [45, 35, 30], cylinder: false) #45L 35W 30H
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
  end

  def ups_rates
    ups = UPS.new(login: ENV["UPS_USERNAME"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_ACCESS_KEY"])
    get_rates_from_shipper(ups)
  end

  def usps_rates
    usps = USPS.new(login: ENV["USPS_USERNAME"], password: ENV["USPS_PASSWORD"])
    get_rates_from_shipper(usps)
  end
end
