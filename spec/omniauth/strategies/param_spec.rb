require 'spec_helper'

describe "OmniAuth::Strategies::Param" do
  let(:app) do
    Rack::Builder.new{ |b|
      b.use Rack::Session::Cookie, :secret => 'abc123'
      b.use OmniAuth::Strategies::Param
      run lambda { |_env| [200, {}, ["Not Found"]] }
    }.to_app
  end

  let(:session) do
    last_request.env['rack.session']
  end

  describe "#request_phase" do
    it "should redirect to callback page" do
      post "/auth/param"
      expect(last_response).to be_redirect
      expect(last_response.headers['Location']).to match(%r{/auth/param/callback})
    end
    it "should store params in session" do
      post "/auth/param", :uid => "hoge", :name => "fuga"
      expect(session["omniauth.params"]["uid"]).to eq "hoge"
      expect(session["omniauth.params"]["name"]).to eq "fuga"
    end
  end

  describe "#callback_phase" do
    let(:auth_hash) { last_request.env['omniauth.auth'] }
    context "success" do
      before do
        sess = {
          'rack.session' => {
            'omniauth.params' => {
              "uid" => "hoge",
              "name" => "fuga"
            }
          }
        }
        post "/auth/param/callback", {}, sess
      end

      it "should store params in callback page" do
        expect(auth_hash.uid).to eq("hoge")
        expect(auth_hash.info["name"]).to eq("fuga")
      end
    end

  end

end
