require 'rewind/rewind'
require 'rewind/rails'
module Rewind
  def self.folder_root
    config_file = File.expand_path Rails.root.join('config', 'rewind.yml')
    if File.exists?(config_file)
      Rails.root.join(*YAML.load(File.read config_file)['root'].split('/'))
    else
      File.expand_path Rails.root.join('test', 'javascripts', 'fixtures')
    end
  end
end
