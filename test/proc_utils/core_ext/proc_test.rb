require 'test_helper'
require 'proc_utils/core_ext/proc'

module ProcUtils
  module CoreExt
    class ProcTest < Minitest::Test
      class Receiver
        def run(*args); args; end
      end

      def test_bind
        func    = proc { |item| item.to_s }
        subject = func.bind(1)
        assert_equal '1', subject.call
      end

      def test_bind_with_args
        receiver = Receiver.new
        func     = proc { |item, *args| item.run(*args) }
        subject  = func.bind(receiver, 1)

        assert_equal [1, 9], subject.call(9)
      end

      def test_partial
        receiver = Receiver.new
        func     = proc { |item, *args| item.run(*args) }
        subject  = func.partial(1)

        assert_equal [1, 9], subject.call(receiver, 9)
      end

      def test_partial_right
        receiver = Receiver.new
        func     = proc { |item, *args| item.run(*args) }
        subject  = func.partial_right(1)

        assert_equal [9, 1], subject.call(receiver, 9)
      end

      def test_flip
        func    = proc { |*args| args }
        subject = func.flip

        assert_equal [2, 1], subject.call(1, 2)
      end

      def test_once
        misses = 0
        func    = proc { misses += 1 }
        subject = func.once

        3.times { subject.call }
        assert_equal 1, misses
      end

      def test_memoize
        misses = 0
        func     = proc { misses += 1}
        subject  = func.memoize
        one, two = 2.times.map { Object.new }

        3.times { subject.call(one) }
        assert_equal 1, misses

        3.times { subject.call(two) }
        assert_equal 2, misses

        3.times { subject.call(one, two) }
        assert_equal 3, misses
      end

      def test_wrap
        inside  = proc { |*args| args }
        outside = proc { |parent, *args| parent.call(1, *args) }
        subject = outside.wrap(inside)

        assert_equal [1, 9], subject.call(9)
      end

      def test_compose
        inside  = proc { |*args| [5, *args] }
        outside = proc { |*args| [1, *args] }
        subject = outside.compose(inside)

        assert_equal [1, 5, 9], subject.call(9)
      end
    end
  end
end
