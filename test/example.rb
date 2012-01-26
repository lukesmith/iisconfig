app_pool do |p|
  p.name 'dasf'
  p.runtime_version :'v2.0'
  p.process_model do |m|
    m.identity_type :NetworkService
  end

  p.site do |s|
    s.name 'add'
    s.binding 'http/*:80:test.local'
    s.binding "net.tcp/808:*"
    s.binding "net.pipe/*"
    s.path 'c:\\temp'
  end
end

app_pool do |p|
  p.name 'asfas'
  p.runtime_version :'v4.0'
  p.pipeline_mode :Integrated
end