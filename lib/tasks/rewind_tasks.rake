namespace :rewind do
  Rake::TestTask.new(:generate => :environment) do |t|
    t.libs << 'spec'
    t.libs << 'test'
    t.test_files = FileList[Rewind.folder_root + '/**/*_fixture.rb']
    t.verbose = false
  end
end