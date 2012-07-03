######################################################################################################################
# Company: Creative Group Services
# Creator: Pieter Martens
######################################################################################################################
class TicTacToe
	# Availble columns for Tic-Tac-Toe
	COLUMNS = { :A1=>" ", :A2=>" ", :A3=>" ", :B1=>" ", :B2=>" ",:B3=>" ", :C1=>" ", :C2=>" ", :C3=>" " }

	# Possible columns combinations to win
	COLUMN_WINNING_RANGES = [	
				[:A1,:A2,:A3], 
				[:B1,:B2,:B3],	
				[:C1,:C2,:C3],
				[:A1,:B1,:C1],
				[:A2,:B2,:C2],
				[:A3,:B3,:C3],
				[:A1,:B2,:C3],
				[:C1,:B2,:A3]
		]


	# Initialize
	def initialize
		ask_username
		determine_cross_or_round
		determine_first_turn
	end

	# Draw application playing board to screen
	def draw_playing_field
		puts ""
		puts "Computer: #{@computer}"
		puts "#{@user_name}: #{@user}"
		puts ""
		puts "   A B C"
		puts " 1 #{COLUMNS[:A1]}|#{COLUMNS[:B1]}|#{COLUMNS[:C1]}"
		puts "   -----"
		puts " 2 #{COLUMNS[:A2]}|#{COLUMNS[:B2]}|#{COLUMNS[:C2]}"
		puts "   -----"
		puts " 3 #{COLUMNS[:A3]}|#{COLUMNS[:B3]}|#{COLUMNS[:C3]}"
		puts ""
	end

	# Ask user for name
	def ask_username
		puts ""
		puts "What is your name?"
		STDOUT.flush
		@user_name = gets.chomp
	end

	# Determine cross or round
	def determine_cross_or_round
		@computer = rand() > 0.5 ? 'X' : 'O'
		@user = @computer == 'X' ? 'O' : 'X'
	end

	# Determine beginning turn
	def determine_first_turn
		if(@user == 'X')
			user_turn
		else
			computer_turn
		end
	end

	# Computer his turn.
	def computer_turn
		move = determine_computer_move
		COLUMNS[move] = @computer
		puts "Computer marks #{move.to_s.upcase}"
		who_wins(@user)
	end

	# Determine computer's next move.
	def determine_computer_move
		# See if 2 columns already in use by player computer.
		COLUMN_WINNING_RANGES.each do |range|
			if times_in_winning_column_range(range, @computer) == 2
				return use_empty_column range
			end
		end
		# See if 2 columns already in use by player user.
		COLUMN_WINNING_RANGES.each do |range|
			if times_in_winning_column_range(range, @user) == 2
				return use_empty_column range
			end
		end
		# See if 1 columns already in use by player computer.
		COLUMN_WINNING_RANGES.each do |range|
			if times_in_winning_column_range(range, @computer) == 1
				return use_empty_column range
			end
		end
		# Nothing spectacular to found.
		key = COLUMNS.keys.to_s;
		length = rand(key.length)
		if COLUMNS[key[length]] == " "
			return key[length]
		else
			#find the first empty slot
			COLUMNS.each { |key,value| return key if value == " " }
		end
	end

	# Counting checked columns in winning possibility's
	def times_in_winning_column_range arr, item
		times = 0
		arr.each do |input| 
			times += 1 if COLUMNS[input.to_sym] == item
			unless COLUMNS[input.to_sym] == item || COLUMNS[input.to_sym] == " "
				return 0
			end
		end
		times
	end

	# Check if somebody wins
	def who_wins(next_turn)
		the_end = nil
		COLUMN_WINNING_RANGES.each do |range|
			# see if computer has won
			if times_in_winning_column_range(range, @computer) == 3
				puts ""
				puts "Computer wins!"
				the_end = true
			end
			# see if user has won
			if times_in_winning_column_range(range, @user) == 3
				puts ""
				puts "#{@user_name} wins!"
				the_end = true
			end
		end
		unless the_end
			if moves_left > 0
				if next_turn == @user
					user_turn
				else
					computer_turn
				end
			else
				puts ""
				puts "Game Over - Ties!"
			end
		end
	end
	
	# User his turn.
	def user_turn
		draw_playing_field
		puts "\n #{@user_name}, make a move."
		STDOUT.flush
		inp = gets.chomp.upcase

		if inp.length == 2
			a = inp.split("")
			if ['A','B','C'].include? a[0]
				if ['1','2','3'].include? a[1]
					if COLUMNS[inp.to_sym] == " "
						COLUMNS[inp.to_sym] = @user
						puts ""
						puts "#{@user_name} marks #{inp.upcase}"
						who_wins(@computer)
					else
						wrong_move
					end
				else
					wrong_input
				end
			else
				wrong_input
			end
		else
			wrong_input
		end
	end

	# Determine empty column
	def use_empty_column arr
		arr.each do |inp| 
			return inp if COLUMNS[inp.to_sym] == " "
		end
	end

	# How many moves left.
	def moves_left
		moves = 0
		COLUMNS.each do |key, value|
			moves += 1 if value == " "
		end
		moves
	end

	# Wrong input message
	def wrong_input
		puts ""
		puts "Wrong input!"
		user_turn
	end
	
	# Player has choosen a wrong move
	def wrong_move
		puts ""
		puts "You must choose an empty column."
		user_turn
	end
end 

TicTacToe.new