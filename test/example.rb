before do
  puts 'before'
end

app_pool do |p|
  p.name :MyAppPool
  p.runtime_version :'v2.0'
  p.start_mode 'AlwaysRunning'
  p.process_model do |m|
    m.identity_type :NetworkService
    m.idle_timeout '0.00:30:00'
  end

  p.site do |s|
    s.name :MySite
    s.path '/'
    s.binding 'http/*:8090:localhost'
    s.binding 'http/*:8090:test.local'
    s.binding "net.tcp/808:*"
    s.binding "net.pipe/*"
    s.physical_path 'c:\\temp\\MySite'

    s.application do |a|
      a.name :MyApp
      a.path '/MyApp'
      a.physical_path 'c:\\temp\\MySite\\MyApp'

      a.virtual_directory do |v|
        v.name :MyAppVirtualDirectory
        v.path '/AppVDir'
        v.physical_path 'c:\\temp\\MySite\MyVDir'
      end
    end

    s.virtual_directory do |v|
      v.name :MySiteVirtualDirectory
      v.path '/SiteVDir'
      v.physical_path 'c:\\temp\\MySite\MyVDir'
    end
  end
end

ftp_site do |s|
  s.name :MyFtp
  s.binding 'ftp://*:21'
  s.physical_path 'c:\\temp\\MyFtp'
  s.enable_authentication :anonymous
  s.allow_authorization [:read, :write], { :users => '*', :roles => '' }
  s.allow_ssl
end

after do
  puts "done"
end