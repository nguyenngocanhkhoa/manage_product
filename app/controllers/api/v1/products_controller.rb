class Api::V1::ProductsController < ApplicationController
  before_action :load_product, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def create
    @product = Product.new product_params
    if @product.save
      render json: {
        status: true,
        data: @product
      },
      status: :created
    else
      render json: {
        status: false,
        error: @product.errors
      },
      status: :unprocessable_entity
    end
  end

  def index
    @products = Product.all
    render json: {
      status: true,
      data: @products
    },
    status: :ok
  end

  def show
    render json: {
      status: true,
      data: @product
    },
    status: :ok
  end

  def update
    if @product.update product_params
      render json: {
        status: true,
        data: @product
      },
      status: :ok
    else
      render json: {
        status: false,
        error: @product.errors
      },
      status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    render json: {
      status: true,
      data: @product
    },
    status: :ok
  end

  private

  def product_params
    params.permit :title, :content
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    render json: {
      status: false,
      message: 'Not found'
    },
    status: :not_found
  end
end
