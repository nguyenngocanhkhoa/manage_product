class ProductUpdater
  def initialize(product, params)
    @product = product
    @params = params
  end

  def call
    if @product.update(@params)
      { success: true, product: @product }
    else
      { success: false, errors: @product.errors }
    end
  end

  private

  attr_reader :product, :params
end