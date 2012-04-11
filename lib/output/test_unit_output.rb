module TestUnitOutput
  def handle_specification(name)  yield  end

  def handle_requirement(description)
    error = yield
    if error.empty?
      print "."
    else
      print error[0..0]
    end
  end

  def handle_summary(started_at)
    puts "", "Finished in #{Time.now - @timer} seconds."
    puts ErrorLog  if Backtraces
    puts "%d tests, %d assertions, %d failures, %d errors" %
      Counter.values_at(:specifications, :requirements, :failed, :errors)
  end
end
