# Set up a chef 0.10 dna.json file (for stack-v1 + stack-v2)
# TODO does this run on non-app-master/solo?
custom_json = config.node.dup
custom_json['run_list'] = 'recipe[main]'

dna_path = "/etc/chef-custom/dna.json"
File.open(dna_path, 'w') do |f|
  f.puts JSON.pretty_generate(custom_json)
  f.chmod(0600)
end

# Runs application cookbooks
run "cd #{config.release_path} && sudo bundle exec chef-solo -c #{config.release_path}/deploy/solo.rb -j #{dna_path}"
run "cat #{config.release_path}/deploy/chef-stacktrace.out 2> /dev/null || echo 'Chef run successful'"
