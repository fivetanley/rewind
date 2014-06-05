require 'fileutils'

module Rewind
	class Fixture
    attr_reader :name, :options
    def initialize(name, options={})
      @name = name
      @options = options
    end

    def run(&block)
      yield
      request, response = eval "[request, response]", block.send(:binding)
      fixture = {
        request: request,
        response: response,
        status: response.status,
        request_headers: request.headers,
        response_headers: response.headers,
        path: request.original_fullpath,
        method: request.method,
        name: name
      }
      FixtureTape.new(fixture)
    end
  end

  class FixtureTape

    def initialize(options={})
      @method = options[:method].downcase
      @request = options[:request]
      @name = options[:name]
      @response = options[:response]
      @body = @response.body
      @status = options[:status]
      @request_headers = options[:request_headers]
      @response_headers = options[:response_headers]
      @path = options[:path]
    end

    def get_binding; binding; end

    def pretty_print_json(json_obj, spaces=4)
      if json_obj
        json = JSON.pretty_generate json_obj
        json.split("\n").map { |s| (" " * spaces) + s }.join("\n")
      else
        ''
      end
    end

  end

  class Folder

    attr_reader :name, :tapes
    def initialize(name, options={})
      @name = name
      @tapes = []
      @options = options
      config_file = YAML.load(File.read(Rails.root.join('config', 'rewind.yml')))
      root = config_file['root']
      @root = Rails.root.join(*root.split('/') + [name])
    end

    def fixture(name, options={}, &block)
      tape = Fixture.new(self.name + '/' + name, options).run(&block)
      write! name, tape 
      @tapes << tape 
    end

    def folder(name, options={}, &block)
      f = Folder.new(self.name + "#{name}", options)
      f.instance_exec(&block)
    end

    def write!(file_name, fixture)
      FileUtils.mkdir_p @root
      File.open(File.expand_path("#{@root}/#{file_name}.js"), 'w+') do |file|
        file.write Writer::Pretender.new(fixture).render
      end
    end

    def run(&block)
      def fixture(name, options={}, &block)
       @tapes << Fixture.new(name, options, &block)
     end
     block.call
   end

 end

 class IntegrationTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::SetupAndTeardown

  class << self
    def folder_root
      @folder_root || ''
    end
    attr_accessor :folder_root, :_folder

    def folder(name, options={}, &block)
      self.folder_root = name
      self._folder = Folder.new(self.folder_root)  
    end

    def fixture(name, options={}, &block)
      test name do
        self.class._folder.fixture(name, options) do
          instance_exec &block
        end
      end
    end
  end

end

  module Writer
    class Pretender
      attr_reader :tape, :file_path

      def initialize(tape)
        @tape = tape
        @file_path = File.expand_path(File.dirname(__FILE__) + '/writers/templates/pretender_globals.js.erb')
      end

      def template
        @template ||= ERB.new(File.read(file_path))
      end

      def render
        template.result(tape.get_binding)
      end
    end
  end
end
