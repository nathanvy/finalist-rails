class PagesController < ApplicationController
  def about
    @version = FINALIST_VERSION
  end
end
