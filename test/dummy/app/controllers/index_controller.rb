class IndexController < ApplicationController

  def show
    render :json => {'hello' => 'goodbye'}
  end

end
