require "csv"
@students = [] 

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit" 
end

def interactive_menu
  loop do
    print_menu
    user_input = menu_selection(STDIN.gets.chomp)
    puts user_input if user_input != nil
  end
end

def menu_selection(selection)
  case selection
    when "1" ; input_students
    when "2" ; show_students
    when "3" ; filename = ask_for_file ; save_students(filename)
    when "4" ; filename = ask_for_file ; load_students(filename)
    when "9" ; exit
  else ; return "#{selection} is not recognised. Please enter a selection:"
  end
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  while !name.empty? do
    add_student name
    puts "Now we have #{@students.count} students"
    name = STDIN.gets.chomp
  end
end

def show_students
  print_header; print_student_list; print_footer
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_student_list
  if @students.length != 0
    @students.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)"}
  else
    puts "There are no students!"
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students"
end

def ask_for_file
  puts "Please enter the file you wish to load:"
  filename = gets.chomp
end

def save_students(filename = "students.csv")
  CSV.open(filename, "w") do |line|
    @students.each do |student|
      student_data = [student[:name], student[:cohort]]
      line << [student[:name], student[:cohort]]
    end
  end
end

def add_student(name, cohort="november")
  @students << {name: name, cohort: cohort.to_sym}
end

def load_students(filename = "students.csv")
  filename = "students.csv" if filename == ""
  if File.exists?(filename)
    CSV.foreach(filename) do |name, cohort|
      add_student name, cohort
      next
    end
  else
    puts "The specified file does not exist!"
  end
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} enteries from #{filename}."
  else
    puts "Sorry, #{filename} doesn't exist!"
    exit
  end
end

try_load_students
interactive_menu