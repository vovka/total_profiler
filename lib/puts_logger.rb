module TotalProfiler
  class PutsLogger
    def info klass, method, file, line, started_at, done_at, res
      puts "#{klass}##{method} done in #{done_at - started_at}. returned #{res.inspect}"
    end
  end
end
