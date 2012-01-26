app_pool do |p|
  p.name :MyAppPool
  p.runtime_version :'v2.0'
  p.process_model do |m|
    m.identity_type :NetworkService
  end

  p.site do |s|
    s.name :MySite
    s.path '/'
    s.binding 'http/*:80:localhost'
    s.binding 'http/*:80:test.local'
    s.binding "net.tcp/808:*"
    s.binding "net.pipe/*"
    s.physical_path 'c:\\temp\\MySite'

    s.application do |a|
      a.name :MyApp
      a.path '/MyApp'
      a.physical_path 'c:\\temp\\MySite\\MyApp'
    end
  end
end