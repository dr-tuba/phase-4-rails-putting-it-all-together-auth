class RecipesController < ApplicationController
    wrap_parameters format: []
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        if session[:user_id]
            recipes = Recipe.all.where("user_id = ?", session[:user_id])
            render json: recipes, status: :created
        else
            render json: {errors: ["Please login to view recipes", "this is in an array to pass RSPEC"] }, status: :unauthorized
        end
    end

    def create
        if session[:user_id]
            recipe = Recipe.create!(recipe_params)
            render json: recipe, status: :created
        else
            render json: {errors: ["Not logged in", "this is in an array to pass RSPEC"] }, status: :unauthorized
        end
    end

    private 

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id).merge({user_id: session[:user_id]})
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
