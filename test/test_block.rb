# frozen_string_literal: true

require "test_helper"

class TestBlock < Minitest::Test
  def test_not_admin_and_not_owner
    user = User.new(2)
    record = Record.new(1, 3)

    refute_predicate BeforeWithBlockPolicy.new(user, record), :edit?
  end

  def test_not_admin_and_owner
    user = User.new(3)
    record = Record.new(1, 3)

    refute_predicate BeforeWithBlockPolicy.new(user, record), :edit?
  end

  def test_admin_and_not_owner
    user = User.new(1)
    record = Record.new(1, 2)

    refute_predicate BeforeWithBlockPolicy.new(user, record), :edit?
  end

  def test_admin_and_owner
    user = User.new(1)
    record = Record.new(1, 1)

    assert_predicate BeforeWithBlockPolicy.new(user, record), :edit?
  end
end
