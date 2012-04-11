module SpecDoxOutput
  def handle_specification(name)
    puts spaces + name
    yield
    puts if Counter[:context_depth] == 1
  end

  def handle_requirement(description)
    print "#{spaces}  - #{description}"
    error = yield
    puts error.empty? ? "" : " [#{error}]"
  end

  def handle_summary(started_at)
    print ErrorLog  if Backtraces
    puts "%d specifications (%d requirements), %d failures, %d errors" %
      Counter.values_at(:specifications, :requirements, :failed, :errors)
  end

  def spaces
    "  " * (Counter[:context_depth] - 1)
  end
end
