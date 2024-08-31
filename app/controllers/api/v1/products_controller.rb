class Api::V1::ProductsController < ApplicationController
  before_action :load_product, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def create
    @product = Product.new(product_params)
    if @product.save
      render_success(@product, :created)
    else
      render_error(@product.errors, :unprocessable_entity)
    end
  end

  def index
    @products = Product.all
    render_success(@products)
  end

  def show
    render_success(@product)
  end

  def update
    if @product.update(product_params)
      render_success(@product)
    else
      render_error(@product.errors, :unprocessable_entity)
    end
  end

  def destroy
    @product.destroy
    render_success(@product)
  end

  private

  def product_params
    params.permit(:title, :content)
  end

  def load_product
    @product = Product.find_by(id: params[:id])
    render_error('Not found', :not_found) unless @product
  end

  def render_success(data, status = :ok)
    render json: { status: true, data: serialize_data(data) }, status: status
  end

  def render_error(message, status)
    render json: { status: false, error: message }, status: status
  end

  def serialize_data(data)
    if data.is_a?(ActiveRecord::Relation)
      ActiveModel::Serializer::CollectionSerializer.new(data, serializer: ProductSerializer)
    else
      ProductSerializer.new(data)
    end
  end
end
