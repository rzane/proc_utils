require 'test_helper'
require 'proc_utils/core_ext/symbol'

module ProcUtils
  module CoreExt
    class SymbolTest < Minitest::Test
      class Receiver
        attr_reader :count

        def initialize
          @count = 0
        end

        def increment(*args)
          @count += 1
        end

        def run(*args)
          args
        end
      end

      def test_bind
        assert_equal '1', :to_s.bind(1).call
      end

      def test_bind_with_args
        receiver = Receiver.new
        subject  = :run.bind(receiver, 1)

        assert_equal [1, 9], subject.call(9)
      end

      def test_partial
        receiver = Receiver.new
        subject  = :run.partial(1)

        assert_equal [1, 9], subject.call(receiver, 9)
      end

      def test_partial_right
        receiver = Receiver.new
        subject  = :run.partial_right(1)

        assert_equal [9, 1], subject.call(receiver, 9)
      end

      def test_once
        receiver = Receiver.new
        subject  = :increment.once

        3.times { subject.call(receiver) }
        assert_equal 1, receiver.count
      end

      def test_memoize
        receiver = Receiver.new
        subject  = :increment.memoize

        3.times { subject.call(receiver) }
        assert_equal 1, receiver.count

        3.times { subject.call(receiver, 1) }
        assert_equal 2, receiver.count

        3.times { subject.call(receiver, 2) }
        assert_equal 3, receiver.count
      end
    end
  end
end
