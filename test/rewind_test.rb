require 'test_helper'
require 'fileutils'
require 'minitest/test'
require 'active_support'

class QuizTest < Rewind::IntegrationTest
  folder 'quizzes'

  setup do
    Rewind::Folder.new('quizzes') do |f|
      f.fixture('hi') do
        get '/', {}, { 'Accept' => 'application/json' }
      end
    end
  end

  teardown do
    FileUtils.rm_rf Rails.root.join('test', 'javascripts')
  end

  # Creates a fixture called hi.js in the folder
  test "creates hi.js file" do
    path = Rails.root.join('test', 'javascripts', 'fixtures', 'quizzes') + 'hi.js'
    assert File.exists? path
    contents = File.read path
    assert contents.match('"hello": "goodbye"'), 'prints some pretty printed json'
  end
end