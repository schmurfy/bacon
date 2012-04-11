
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
    error_type, err = yield
    
    # goto beginning of line
    print "\e[G\e[K"
    
    case error_type
    when ""
      puts "#{spaces} #{Color.green}✔#{Color.reset} #{description}"
      
    when :failed
      puts "#{spaces} #{Color.red}✘#{Color.reset} #{description}"
    
    when :error
      # ❍ ☻
      puts "#{spaces} #{Color.red}☁ #{description}#{Color.reset} [#{err.class}]"
      
    end
    
  end

  def handle_summary(started_at)
    elapsed_time = Time.now.to_i - started_at.to_i
    print ErrorLog  if Backtraces
    puts "Execution time: #{human_duration(elapsed_time)}"
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
