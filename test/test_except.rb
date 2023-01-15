# frozen_string_literal: true

require "test_helper"

class TestExcept < Minitest::Test
  class ExceptPolicy < BasePolicy
    before :check_admin, except: :destroy?

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
    policy = ExceptPolicy.new(user)

    assert_predicate policy, :edit?
    refute_predicate policy, :destroy?
  end

  def test_user
    user = User.new(2)
    policy = ExceptPolicy.new(user)

    refute_predicate policy, :edit?
    refute_predicate policy, :destroy?
  end
end
