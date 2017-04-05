require "proc_utils/version"

module ProcUtils
  ALL = %i(partial partial_right bind flip wrap compose memoize once)

  class << self
    def partial(subject, *bound_args)
      proc { |receiver, *args| subject.call(receiver, *bound_args, *args) }
    end

    def partial_right(subject, *bound_args)
      proc { |receiver, *args| subject.call(receiver, *args, *bound_args) }
    end

    def bind(subject, receiver, *bound_args)
      proc { |*args| subject.call(receiver, *bound_args, *args) }
    end

    def flip(subject)
      proc { |*args| subject.call(*args.reverse) }
    end

    def wrap(subject, other)
      proc { |*args| subject.call(other, *args) }
    end

    def compose(subject, other)
      proc { |*args| subject.call(*other.call(*args)) }
    end

    def memoize(subject)
      cache = {}
      proc { |*args| cache[args] ||= subject.call(*args) }
    end

    def once(subject)
      cache, called = nil, false

      proc do |*args|
        cache, called = subject.call(*args), true unless called
        cache
      end
    end
  end
end
