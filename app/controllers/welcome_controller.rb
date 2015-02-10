class WelcomeController < ApplicationController
  def index
    @pages = []
    Dir.foreach("app/controllers") do |x|
      if x.end_with?("_controller.rb")
        page = x.split("_controller.rb")[0]
        @pages << page unless page == "application" or page == "welcome"
      end
    end
    @pages.sort!
  end
end
