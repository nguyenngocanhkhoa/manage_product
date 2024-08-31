require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all products' do
      products = create_list(:product, 3)
      get :index
      expect(JSON.parse(response.body)['data'].size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns a success response' do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the requested product' do
      get :show, params: { id: product.id }
      expect(JSON.parse(response.body)['data']['id']).to eq(product.id)
    end

    it 'returns not found if product does not exist' do
      get :show, params: { id: -1 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { attributes_for(:product) }

      it 'creates a new product' do
        expect {
          post :create, params: valid_attributes
        }.to change(Product, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: nil, content: nil } }

      it 'does not create a new product' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Product, :count).by(0)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:product) { create(:product) }

    context 'with valid parameters' do
      let(:new_attributes) { attributes_for(:product) }

      it 'updates the requested product' do
        put :update, params: { id: product.id, title: new_attributes[:title], content: new_attributes[:content] }
        product.reload
        expect(product.title).to eq(new_attributes[:title])
        expect(product.content).to eq(new_attributes[:content])
      end

      it 'returns a success response' do
        put :update, params: { id: product.id, title: new_attributes[:title], content: new_attributes[:content] }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: nil, content: nil } }

      it 'does not update the product' do
        put :update, params: { id: product.id, title: invalid_attributes[:title], content: invalid_attributes[:content] }
        product.reload
        expect(product.title).not_to be_nil
        expect(product.content).not_to be_nil
      end

      it 'returns an unprocessable entity status' do
        put :update, params: { id: product.id, title: invalid_attributes[:title], content: invalid_attributes[:content] }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { create(:product) }

    it 'destroys the requested product' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
