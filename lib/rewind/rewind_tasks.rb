  Rake::TestTask.new do |t|
    t.name = 'rewind'
    t.files = FileList[Rewind.folder_root + '/**/*']
    t.verbose = false
  end