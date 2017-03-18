require 'test_helper'

class ProcUtilsTest < Minitest::Test
  def setup
    @receiver = Object.new

    def @receiver.run(*args)
      args
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::ProcUtils::VERSION
  end

  def test_bind
    subject = :to_s.bind(1)
    assert_equal '1', subject.call
  end

  def test_bind_with_args
    subject = :run.bind(@receiver, 1)
    assert_equal [1, 9], subject.call(9)
  end

  def test_partial
    subject = :run.partial(1)
    assert_equal [1, 9], subject.call(@receiver, 9)
  end

  def test_partial_right
    subject = :run.partial_right(1)
    assert_equal [9, 1], subject.call(@receiver, 9)
  end

  def test_flip
    subject = proc { |*args| args }.flip
    assert_equal [2, 1], subject.call(1, 2)
  end

  def test_once
    misses = 0
    subject = proc { misses += 1 }.once

    3.times { subject.call }
    assert_equal 1, misses
  end

  def test_memoize
    misses = 0
    subject = proc { misses += 1 }.memoize
    one, two = 2.times.map { Object.new }

    3.times { subject.call(one) }
    assert_equal 1, misses

    3.times { subject.call(two) }
    assert_equal 2, misses

    3.times { subject.call(one, two) }
    assert_equal 3, misses
  end

  def test_wrap
    wrapped = proc { |*args| args }
    subject = proc { |parent, *args| parent.call(1, *args) }.wrap(wrapped)

    assert_equal [1, 9], subject.call(9)
  end

  def test_compose
    wrapped = proc { |*args| [5, *args] }
    subject = proc { |*args| [1, *args]  }.compose(wrapped)

    assert_equal [1, 5, 9], subject.call(9)
  end
end
