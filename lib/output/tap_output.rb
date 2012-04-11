module TapOutput
  def handle_specification(name)  yield  end

  def handle_requirement(description)
    ErrorLog.replace ""
    error = yield
    if error.empty?
      puts "ok %-3d - %s" % [Counter[:specifications], description]
    else
      puts "not ok %d - %s: %s" %
        [Counter[:specifications], description, error]
      puts ErrorLog.strip.gsub(/^/, '# ')  if Backtraces
    end
  end

  def handle_summary(started_at)
    puts "1..#{Counter[:specifications]}"
    puts "# %d tests, %d assertions, %d failures, %d errors" %
      Counter.values_at(:specifications, :requirements, :failed, :errors)
  end
end
