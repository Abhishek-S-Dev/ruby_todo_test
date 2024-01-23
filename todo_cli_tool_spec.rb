require 'rspec'
require_relative 'todo_cli_tool'
require 'rest-client'
require 'net/http'
require 'byebug'

describe 'TodoCliTool' do

  describe '.print_todo_response' do
    context 'when the response code is 200' do
      it 'prints the todo' do
        BASE_URL = 'https://jsonplaceholder.typicode.com/todos/'.freeze
        todo_url = "#{BASE_URL}2"
        @response = RestClient.get(todo_url)
        @index = 1
        expect(CliTodo).to receive(:print_todo).with(JSON.parse(@response.body))
        CliTodo.print_todo_response(@response, @index)
      end
    end

    context 'when the response code is not 200' do
      it 'prints an error message' do
        @response = Net::HTTPResponse.new(1.0, 404, 'Not Found')
        @index = 1
        expect { CliTodo.print_todo_response(@response, @index) }.to output(/Failed to fetch TODO at index/).to_stdout
      end
    end
  end
end