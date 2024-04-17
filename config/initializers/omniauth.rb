Rails.application.config.middleware.use OmniAuth::Builder do
    provider :canvas, "CANVAS_CLIENT_ID", "CANVAS_CLIENT_SECRET", :client_options => {
      :site => 'https://<your-canvas-url>.instructure.com'
    }
  end
  