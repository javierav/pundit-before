# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pundit/before"

require "minitest/autorun"

class User
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def admin?
    id == 1
  end

  def root?
    id.zero?
  end
end

class BasePolicy
  include Pundit::Before
  attr_reader :user

  def initialize(user)
    @user = user
  end
end
