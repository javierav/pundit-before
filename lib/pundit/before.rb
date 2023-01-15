# frozen_string_literal: true

require "active_support/callbacks"
require "active_support/core_ext/array/wrap"
require "active_support/core_ext/module/redefine_method"
require "active_support/core_ext/object/blank"

require_relative "before/version"

module Pundit
  module Before
    # rubocop:disable Metrics/MethodLength
    def self.included(base)
      base.extend ClassMethods
      base.include ActiveSupport::Callbacks

      base.class_eval do
        define_callbacks :_pundit_before, skip_after_callbacks_if_terminated: true

        def self.method_added(method_name)
          super

          return unless method_name.to_s =~ /.*\?$/ && public_method_defined?(method_name)
          return if @_pundit_before_running

          @_pundit_before_running = true

          old_method = instance_method(method_name)

          redefine_method(method_name) do
            @_pundit_before_result = nil
            @_pundit_before_method = method_name

            run_callbacks :_pundit_before

            @_pundit_before_result.nil? ? old_method.bind(self).call : @_pundit_before_result
          end

          @_pundit_before_running = false
        end
      end
    end
    # rubocop:enable Metrics/MethodLength

    class CallbackFilter
      def initialize(methods)
        @methods = Array(methods).map(&:to_sym)
      end

      def match?(object)
        @methods.include?(object.instance_variable_get(:@_pundit_before_method).to_sym)
      end

      alias after  match?
      alias before match?
      alias around match?
    end

    module ClassMethods
      def before(*method_names, **options, &block)
        _normalize_callback_options(options)

        if block_given?
          set_callback :_pundit_before, :before, **options, &block
        else
          set_callback :_pundit_before, :before, *method_names, **options
        end
      end

      def skip_before(*method_names, **options)
        _normalize_callback_options(options)
        skip_callback :_pundit_before, :before, *method_names, **options
      end

      def _normalize_callback_options(options)
        _normalize_callback_option(options, :only, :if)
        _normalize_callback_option(options, :except, :unless)
      end

      def _normalize_callback_option(options, from, to)
        return unless (from = options.delete(from))

        from = CallbackFilter.new(from)
        options[to] = Array(options[to]).unshift(from)
      end
    end

    def allow!
      @_pundit_before_result = true
      throw :abort
    end

    def deny!
      @_pundit_before_result = false
      throw :abort
    end
  end
end
