require 'bozo_scripts'

package_with :rubygems

resolve_dependencies_with :bundler

publish_with :rubygems
post_publish :git_tag_release

with_hook :teamcity
with_hook :git_commit_hashes