require 'proc_utils'

module ProcUtils
  module CoreExt
    module Symbol
      ProcUtils::NAMES.each do |meth|
        define_method name do |*args|
          ProcUtils.send(meth, to_proc, *args)
        end
      end
    end
  end
end

::Symbol.prepend ProcUtils::CoreExt::Symbol
