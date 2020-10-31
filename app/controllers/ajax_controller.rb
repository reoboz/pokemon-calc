class AjaxController < ApplicationController
  def search
    result = Pokemon.where("name like ?", "%#{params[:name]}%").pluck(:name)
    # puts result
    render :json => result
  end

  def new
  end
end
