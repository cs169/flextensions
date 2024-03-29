quire 'rails_helper'

module Api
    module V1

        RSpec.describe UsersController, type: :controller do

            describe "GET #index" do
                it "throws a 501 error" do
                    get :index
                    expect(response.status).to eq(501)
                end
            end

            describe "POST #create" do
                it "throws a 501 error" do
                    post :create
                    expect(response.status).to eq(501)
                end
            end

            describe "DELETE #destroy" do
                it "throws a 501 error" do
                    delete :destroy, params: { id: 1 }
                    expect(response.status).to eq(501)
                end
            end
        end
    end
end