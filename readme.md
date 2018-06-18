# IISConfig

IISConfig is a DSL written in ruby to configure IIS application pools and web and ftp sites.

## Examples

By default `iisconfig` is destructive, any application pools or sites in the configuration
file will be deleted before being rebuilt.

```shell
iisconfig e config.iis
```

If you want to recycle just the application pools the `--recycle-apppools` can be used

```shell
iisconfig e config --recycle-apppools
```

To perform a dry run, and to see what `appcmds` will be executed add the switch `dry-run`

```shell
iisconfig e config.iis --dry-run
```

Within the `config.iis` `SensitiveValue` can be used to store passwords or any other sensitive
data and prevent it being logged.

E.g.

```ruby
p.process_model do |m|
  m.identity_type :SpecificUser
  m.idle_timeout '0.00:30:00'
  m.username ENV['APP_POOL_USERNAME']
  m.password SensitiveValue.new(ENV['APP_POOL_PASSWORD'])
end
```

## Notes

`iisconfig` must be run with administrative privileges.