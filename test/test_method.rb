# frozen_string_literal: true

require "test_helper"

class TestMethod < Minitest::Test
  class MethodPolicy < BasePolicy
    before :check_admin

    def edit?
      false
    end

    private

    def check_admin
      allow! if user.admin?
    end
  end

  def test_admin
    user = User.new(1)
    policy = MethodPolicy.new(user)

    assert_predicate policy, :edit?
  end

  def test_user
    user = User.new(2)
    policy = MethodPolicy.new(user)

    refute_predicate policy, :edit?
  end
end
