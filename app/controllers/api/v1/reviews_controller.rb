module Api
  module V1
    # Review api controller
    class ReviewsController < ApplicationController
      def create
        review = Review.create(review_params)
        if review.save
          render json: ReviewSerializer.new(review).serialized_json
        else
          render json: { error: review.errors.messages }, status: 422
        end
      end

      def destroy
        review = Review.find(params[:id])
        if review.destroy
          # This method sends info related to the error on the head of the response with a 204 error code (no_content)
          head :no_content
        else
          render json: { error: review.errors.messages }, status: 422
        end
      end

      private

      def review_params
        params.require(:review).permit(:title, :description, :score, :airline_id)
      end
    end
  end
end
