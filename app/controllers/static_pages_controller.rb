class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  
  def about
  end

  def contact_help
  end

  def privacy
  end

  def terms
  end
end
