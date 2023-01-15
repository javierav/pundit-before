# frozen_string_literal: true

require "test_helper"

class TestOnly < Minitest::Test
  class OnlyPolicy < BasePolicy
    before :check_admin, only: :destroy?

    def edit?
      false
    end

    def destroy?
      false
    end

    private

    def check_admin
      allow! if user.admin?
    end
  end

  def test_admin
    user = User.new(1)
    policy = OnlyPolicy.new(user)

    refute_predicate policy, :edit?
    assert_predicate policy, :destroy?
  end

  def test_user
    user = User.new(2)
    policy = OnlyPolicy.new(user)

    refute_predicate policy, :edit?
    refute_predicate policy, :destroy?
  end
end
