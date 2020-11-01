class Api::V1::Auth::RegistrationsController < ApplicationController
  def create
    # binding.pry
    super do |resource|
      resource.do_something(extra)
    end
  end
end
