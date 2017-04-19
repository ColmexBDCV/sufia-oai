module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    module_function :escape

    def unescape(s)
      CGI.unescape(s)
    end
    module_function :unescape
  end
end
