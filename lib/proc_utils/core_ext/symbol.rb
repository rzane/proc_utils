require 'proc_utils'

module ProcUtils
  module CoreExt
    module Symbol
      ProcUtils::SYM.each do |meth|
        define_method meth do |*args|
          ProcUtils.send(meth, to_proc, *args)
        end
      end
    end
  end
end

::Symbol.prepend ProcUtils::CoreExt::Symbol
