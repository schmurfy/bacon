# encoding: utf-8

require 'term/ansicolor'

Color = Term::ANSIColor

module BetterOutput
  def handle_specification(name)
    puts "\n#{spaces()}#{Color.underscore}#{name}#{Color.reset}"
    yield
    puts if Counter[:context_depth] == 1
  end

  def handle_requirement(description)
    print "#{spaces} ~ #{description}"
    timing = []
    error_type, err = yield(timing)
    
    # goto beginning of line
    print "\e[G\e[K"
    
    case error_type
    when ""
      before_duration = (timing[0] * 1000).to_i
      test_duration = (timing[1] * 1000).to_i
      total = (timing.inject(:+) * 1000 ).to_i
      
      puts "#{spaces} #{Color.green}✔#{Color.reset} #{description} [#{total} ms (#{before_duration} + #{test_duration})]"
      
    when :failed
      puts "#{spaces} #{Color.red}✘#{Color.reset} #{description}"
    
    when :error
      # ❍ ☻
      puts "#{spaces} #{Color.red}☁ #{description}#{Color.reset} [#{err.class}]"
      
    end
    
  end

  def handle_summary(elapsed_time)
    print ErrorLog  if Backtraces
    if elapsed_time < 1
      puts "Execution time: #{elapsed_time * 1000} ms"
    else
      puts "Execution time: #{human_duration(elapsed_time)}"
    end
    puts "%d specifications (%d requirements), %d failures, %d errors" %
      Counter.values_at(:specifications, :requirements, :failed, :errors)
  end

  def spaces(str = " ")
    str * 2 * (Counter[:context_depth] - 1)
  end

private
  
  def human_duration(secs)
    [[60, 'seconds'], [60, 'minutes'], [24, 'hours'], [1000, 'days']].map do |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        (n > 0) ? "#{n.to_i} #{name}" : nil
      end
    end.compact.reverse.join(' ')
  end
end
