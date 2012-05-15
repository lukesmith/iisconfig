before do
  puts 'before'
end

app_pool do |p|
  p.name :MyAppPool
  p.runtime_version :'v2.0'
  p.process_model do |m|
    m.identity_type :NetworkService
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

app_pool do |p|
  p.name 'Default-Web-Site'
  p.runtime_version :'v2.0'
  p.pipeline_mode 'Classic'
  p.process_model do |pm|
    pm.identity_type 'NetworkService'
  end

  p.site do |s|
    s.name 'Default Web Site'
    s.path '/'
    s.physical_path 'C:\\inetpub\\wwwroot'
    s.binding "http/*:8088:localhost"
  end
end

after do
  puts "done"
end