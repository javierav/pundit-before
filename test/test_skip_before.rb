# frozen_string_literal: true

require "test_helper"

class TestSkipBefore < Minitest::Test
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

  class InheritedPolicy < MethodPolicy
    skip_before :check_admin
  end

  def test_admin
    user = User.new(1)
    policy = InheritedPolicy.new(user)

    refute_predicate policy, :edit?
  end

  def test_user
    user = User.new(2)
    policy = InheritedPolicy.new(user)

    refute_predicate policy, :edit?
  end
end
