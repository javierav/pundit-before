# frozen_string_literal: true

require "test_helper"

class TestMultipleMethods < Minitest::Test
  class MultipleMethodsPolicy < BasePolicy
    before :check_admin, :check_root

    def edit?
      false
    end

    private

    def check_admin
      allow! if user.admin?
    end

    def check_root
      allow! if user.root?
    end
  end

  def test_root
    user = User.new(0)
    policy = MultipleMethodsPolicy.new(user)

    assert_predicate policy, :edit?
  end

  def test_admin
    user = User.new(1)
    policy = MultipleMethodsPolicy.new(user)

    assert_predicate policy, :edit?
  end

  def test_user
    user = User.new(2)
    policy = MultipleMethodsPolicy.new(user)

    refute_predicate policy, :edit?
  end
end
