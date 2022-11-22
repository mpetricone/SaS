module DebugHelper
    @@default_noerror = "{DEBUG->INFO}"
    @@default_start = "||"
    def debug_noerror(message)
        content_tag :span, "#{@@default_start}#{@@default_noerror}#{message}#{@@default_noerror}#{@@default_start}", class: 'debug-noerror'
    end
end
