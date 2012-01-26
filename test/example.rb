app_pool do |p|
  p.name 'dasf'
  p.runtime_version :'v2.0'

  p.site do |s|
    s.name 'add'
    s.binding 'http/*:80:test.local'
    s.path 'c:\\temp'
  end
end

app_pool do |p|
  p.name 'asfas'
  p.runtime_version :'v4.0'
  p.pipeline_mode :Integrated
end