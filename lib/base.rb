module TotalProfiler
  class Base
    class << self
      def monkeypatch!
        @logger = TotalProfiler::Config.logger || TotalProfiler::PutsLogger
        @logger = @logger.new if @logger.is_a? Class
        TotalProfiler::Config.classes.each{ |klass| self.monkeypatch_class(klass) }
      end
      
      def monkeypatch_class klass
        methods_to_patch = klass[:methods]
        klass = klass[:class]
        if methods_to_patch.nil?
          if TotalProfiler::Config.profile_all?
            methods_to_patch = klass.methods
          else
            methods_to_patch = []
          end
        end
        methods_to_patch.each{ |method| monkeypatch_method klass, method }
      end
      
      def monkeypatch_method klass, method
        klass.class_eval <<-EOS
          alias_method :old_#{method}, :#{method}
          def #{method} *args
            started_at = Time.now
            res = old_#{method}(*args)
            done_at = Time.now
            TotalProfiler::Base.log #{klass}, :#{method}, __FILE__, __LINE__, started_at, done_at, res
            res
          end
        EOS
      end
      
      def log *args#klass, method, file, line, started_at, done_at, res
        @logger.info *args#klass, method, started_at, done_at, res
      end
    end
  end
end
