require 'proc_utils'

module ProcUtils
  module CoreExt
    module Proc
      ProcUtils::NAMES.each do |meth|
        define_method meth do |*args|
          ProcUtils.send(meth, self, *args)
        end
      end
    end
  end
end

::Proc.prepend ProcUtils::CoreExt::Proc
