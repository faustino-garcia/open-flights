module Api
  module V1
    # Airlines api controller
    class AirlinesController < ApplicationController
      def index
        airlines = Airline.all
        render json: AirlineSerializer.new(airlines, options).serialized_json
      end

      def show
        airline = Airline.find_by(slug: params[:slug])
        render json: AirlineSerializer.new(airline, options).serialized_json
      end

      def create
        airline = Airline.create(airline_params)
        if airline.save
          render json: AirlineSerializer.new(airline).serialized_json
        else
          render json: { error: airline.errors.messages }, status: 422
        end
      end

      def update
        airline = Airline.find_by(slug: params[:slug])
        if airline.update(airline_params)
          render json: AirlineSerializer.new(airline, options).serialized_json
        else
          render json: { error: airline.errors.messages }, status: 422
        end
      end

      def destroy
        airline = Airline.find_by(slug: params[:slug])
        if airline.destroy
          # This method sends info related to the error on the head of the response with a 204 error code (no_content)
          head :no_content
        else
          render json: { error: airline.errors.messages }, status: 422
        end
      end

      private

      def airline_params
        params.require(:airline).permit(:name, :image_url)
      end

      def options
        # This method includes all the associated reviews to the airline serializer for the compound doc
        @options ||= { include: %i[reviews] }
      end
    end
  end
end
