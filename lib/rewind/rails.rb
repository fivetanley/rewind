if defined?(Rake.application)
  ENV['RAILS_ENV'] ||= 'test'
end
module Rails
  class RewindRailtie < ::Rails::Railtie
    rake_tasks do
      load File.expand_path("../../tasks/rewind_tasks.rake", __FILE__)
    end
  end
end