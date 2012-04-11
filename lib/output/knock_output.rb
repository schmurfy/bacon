module KnockOutput
  def handle_specification(name)  yield  end

  def handle_requirement(description)
    ErrorLog.replace ""
    error = yield
    if error.empty?
      puts "ok - %s" % [description]
    else
      puts "not ok - %s: %s" % [description, error]
      puts ErrorLog.strip.gsub(/^/, '# ')  if Backtraces
    end
  end

  def handle_summary(started_at);  end
end
