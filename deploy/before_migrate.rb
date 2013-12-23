# Set up a chef 0.10 dna.json file (for stack-v1 + stack-v2)
# TODO does this run on non-app-master/solo?
require "json"

custom_json = config.node.dup
custom_json['run_list'] = 'recipe[main]'

dna_path = File.join(config.release_path, "deploy", "dna.json")
dna_target = "/etc/chef-custom/dna.json"

File.open(dna_path, 'w') do |f|
  f.puts JSON.pretty_generate(custom_json)
  f.chmod(0600)
end

# Runs application cookbooks
sudo "cp -f #{dna_path} #{dna_target}"
run "cd #{config.release_path} && sudo bundle exec chef-solo -c #{config.release_path}/deploy/solo.rb -j #{dna_target}"
run "cat #{config.release_path}/deploy/chef-stacktrace.out 2> /dev/null || echo 'Chef run successful'"
