# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index
    render text: 'abc'
  end
end
