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

class Record
  attr_reader :id, :owner_id

  def initialize(id, owner_id)
    @id = id
    @owner_id = owner_id
  end
end

class BeforeWithMethodPolicy
  include Pundit::Before
  attr_reader :user, :record

  before :check_admin

  def initialize(user, record)
    @user = user
    @record = record
  end

  def edit?
    record.owner_id == user.id
  end

  private

  # if user is admin allow to edit without other checks
  def check_admin
    allow! if user_admin?
  end

  def user_admin?
    user.admin?
  end
end

class BeforeWithBlockPolicy
  include Pundit::Before
  attr_reader :user, :record

  # only admins can edit
  before do
    deny! unless user.admin?
  end

  def initialize(user, record)
    @user = user
    @record = record
  end

  def edit?
    record.owner_id == user.id
  end
end

class BeforeInheritancePolicy < BeforeWithMethodPolicy
  before :check_root

  private

  # if user is root allow to edit without other checks
  def check_root
    allow! if user.root?
  end
end
