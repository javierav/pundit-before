# frozen_string_literal: true

require "test_helper"

class TestBlock < Minitest::Test
  class BlockPolicy < BasePolicy
    before do
      deny! unless user.admin?
    end

    def edit?
      true
    end
  end

  def test_admin
    user = User.new(1)
    policy = BlockPolicy.new(user)

    assert_predicate policy, :edit?
  end

  def test_user
    user = User.new(2)
    policy = BlockPolicy.new(user)

    refute_predicate policy, :edit?
  end
end
