class HomeController < ApplicationController
    def index
      @team_members = [ "Eric", "Dorian", "Dana", "Tianye", "Tashrique", "Yamal" ]
    end
  end