# frozen_string_literal: false

# Connect four game on terminal
class ConnectFour
  def get_input
    loop do
      input = gets.chomp
      verified_num = verify_input(input.to_i) if input.match?(/^\d$/)

      return verified_num if verified_num

      puts 'Invalid input. Please try again.'
    end
  end

  def verify_input(input_num)
    input_num if input_num.between?(0, 6)
  end
end
