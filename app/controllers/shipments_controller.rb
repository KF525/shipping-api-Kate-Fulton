class ShipmentsController < ApplicationController

  def index
    @shipments = Shipment.all
    render json: @shipments
  end

  def new
    @shipment = Shipment.new
  end

  #http://localhost:3000/shipments/new?shipment[city]=Seattle&shipment[state]=WA&shipment[postal_code]=98118&shipment[weight]=100

  def create
    @shipment = Shipment.new(params.require(:shipment).permit(:city, :state, :postal_code, :weight))
    if @shipment.save
      result = []
      result.append(@shipment.ups_rates.as_json(only: ["carrier", "service_name", "currency", "total_price"])) #need to total_price/100.0
      result.append(@shipment.usps_rates.collect do |shipment|
        { carrier: shipment.carrier,
          service_name: shipment.service_name,
          total_price: shipment.package_rates[0][:rate],
          currency: shipment.currency
        }
      end)

      render json: result.as_json
      #is this where it is logged?
    else
      render json: {error: "Something went wrong. Please make sure you have provided all necessary information."}
    end
  end

end
