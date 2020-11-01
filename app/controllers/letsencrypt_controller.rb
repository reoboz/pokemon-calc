class LetsencryptController < ApplicationController
  def index
    if ENV["LETS_ENCRYPT_CHALLENGE"]
      render text: ENV["LETS_ENCRYPT_CHALLENGE"], layout: nil
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end