require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:original_url) { 'http://heymamam.com' }

  let(:valid_attributes) do
    { original_url: original_url }
  end

  let(:invalid_attributes) do
    { original_url: '' }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Url.create! valid_attributes

      get :index

      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    context 'with valid token' do
      it 'redirects to the original url' do
        url = Url.create! valid_attributes

        get :show, params: { token: url.token }

        expect(response).to have_http_status(:moved_permanently)
        expect(response).to redirect_to(url.original_url)
      end
    end

    context 'with invalid token' do
      it 'redirects to the homepage' do
        Url.create! valid_attributes

        get :show, params: { token: '1234567' }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new shortened url' do
        expect do
          post :create, params: { url: valid_attributes }
        end.to change(Url, :count).by(1)
      end

      it 'redirects to the homepage' do
        post :create, params: { url: valid_attributes }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it 'does not create a new shortened url' do
        expect do
          post :create, params: { url: invalid_attributes }
        end.to_not change(Url, :count)
      end

      it 'does not redirect' do
        post :create, params: { url: invalid_attributes }

        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested url' do
      url = Url.create! valid_attributes

      expect do
        delete :destroy, params: { id: url.to_param }
      end.to change(Url, :count).by(-1)
    end

    it 'redirects to the homepage' do
      url = Url.create! valid_attributes

      delete :destroy, params: { id: url.to_param }

      expect(response).to redirect_to(root_path)
    end
  end
end
