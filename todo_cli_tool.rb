require 'json'
require 'rest-client'
require 'byebug'

class CliTodo
  BASE_URL = 'https://jsonplaceholder.typicode.com/todos/'.freeze
  @responses = []
  @max_name_length = 51 # default error message length

  def self.fetch_todos
    (1..20).each do |index|
      todo_url = "#{BASE_URL}#{2 * (index)}"
      response = RestClient.get(todo_url)
      if response.code == 200
        @max_name_length = JSON.parse(response.body)['title'].length  if JSON.parse(response.body)['title'].length > @max_name_length
      end 
      @responses << response
    end
    self.print_todos(@responses)
  end

  def self.print_todos(responses)
    # heading = "Title | Completed"
    # equal spaces on both sides of the heading
    # -6 for cut lenth of "title" and space aroud it
    puts "# #{' ' * ((@max_name_length -6)/2) } Title #{' ' * ((@max_name_length -6 )/2) }| Completed #"
    puts "# #{'-' * (@max_name_length + 11)} #" # add 11 for space occupy by completed
    
    # printing responses 
    responses.each_with_index do |response, index|
      print_todo_response(response, index)
    end
  end

  def self.print_todo_response(response, index)
    if response.code == 200
      print_todo(JSON.parse(response.body))
    else
      print "# Failed to fetch TODO at index #{(index + 1) * 2}. Status code: #{response.code}"
      # print reminaing spaces
      # add 11 for space occupy by completed 
      # and substract 51 for error message length
      puts " #{' ' * (@max_name_length + 11 - 51)} #"
      
      puts "# #{'-' * (@max_name_length + 11)} #"
    end
  end

  def self.print_todo(todo)
    puts "# #{todo['title']}#{' ' * (@max_name_length - todo['title'].length)}| #{todo['completed'] ? 'Yes' : 'No '}#{' ' * 6} #"

    puts "# #{'-' * (@max_name_length + 11)} #"
    # add 11 for space occupy by completed
  end
end

# main method
CliTodo.fetch_todos