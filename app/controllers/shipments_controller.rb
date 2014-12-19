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
      result.append(@shipment.ups_rates.as_json(only: ["carrier", "service_name", "currency", "total_price"]))
      result.append(@shipment.usps_rates.collect do |shipment|
        { carrier: shipment.carrier,
          service_name: shipment.service_name,
          total_price: shipment.package_rates[0][:rate],
          currency: shipment.currency
        }
      end)
      Log.create(response: result.as_json, params: params.as_json, ip_address: env["REMOTE_HOST"], url: env["REQUEST_URI"])
      render json: result.as_json
    else
      render json: {error: "Something went wrong. Please make sure you have provided all necessary information."}
    end
  end

end
