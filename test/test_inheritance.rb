# frozen_string_literal: true

require "test_helper"

class TestInheritance < Minitest::Test
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
    before :check_root

    private

    def check_root
      allow! if user.root?
    end
  end

  def test_root
    user = User.new(0)
    policy = InheritedPolicy.new(user)

    assert_predicate policy, :edit?
  end

  def test_admin
    user = User.new(1)
    policy = InheritedPolicy.new(user)

    assert_predicate policy, :edit?
  end

  def test_user
    user = User.new(2)
    policy = InheritedPolicy.new(user)

    refute_predicate policy, :edit?
  end
end
