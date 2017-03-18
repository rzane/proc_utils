require "proc_utils/version"

module ProcUtils
  module ProcExtensions
    def partial(*bound_args)
      proc { |receiver, *args| call(receiver, *bound_args, *args) }
    end

    def partial_right(*bound_args)
      proc { |receiver, *args| call(receiver, *args, *bound_args) }
    end

    def bind(receiver, *bound_args)
      proc { |*args| call(receiver, *bound_args, *args) }
    end

    def flip
      proc { |*args| call(*args.reverse) }
    end

    def wrap(other)
      proc { |*args| call(other, *args) }
    end

    def compose(other)
      proc { |*args| call(*other.call(*args)) }
    end

    def memoize
      cache = {}
      proc { |*args| cache[args] ||= call(*args) }
    end

    def once
      cache, called = nil, false

      proc do |*args|
        cache, called = call(*args), true unless called
        cache
      end
    end
  end

  module SymbolExtensions
    %i(bind partial partial_right).each do |name|
      define_method name do |*args|
        to_proc.send(name, *args)
      end
    end
  end
end

Proc.prepend ProcUtils::ProcExtensions
Symbol.prepend ProcUtils::SymbolExtensions
