# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/module/redefine_method"
require "active_support/core_ext/object/blank"

require_relative "before/version"

module Pundit
  module Before
    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    def self.included(base)
      base.extend ClassMethods

      base.class_eval do
        class_attribute :_pundit_before, default: []

        def self.method_added(method_name)
          super

          return if @_pundit_before_running
          return unless method_name.to_s =~ /.*\?$/ && public_method_defined?(method_name)

          @_pundit_before_running = true

          old_method = instance_method(method_name)

          redefine_method(method_name) do
            result = catch :halt do
              (_pundit_before.presence || []).each do |name, block|
                name.present? ? send(name) : instance_eval(&block)
              end
              nil
            end

            result.nil? ? old_method.bind(self).call : result
          end

          @_pundit_before_running = false
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

    module ClassMethods
      def before(method_name=nil, &block)
        self._pundit_before = _pundit_before.dup.push([method_name, block])
      end
    end

    def allow!
      throw :halt, true
    end

    def deny!
      throw :halt, false
    end
  end
end
