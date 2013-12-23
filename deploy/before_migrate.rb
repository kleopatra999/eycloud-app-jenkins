custom_json = config.node.dup
custom_json['run_list'] = 'recipe[main]'

dna_path = File.join(config.release_path, "deploy", "dna.json")
dna_target = "/etc/chef-custom/dna.json"

File.open(dna_path, 'w') do |f|
  f.puts custom_json.to_json
  f.chmod(0600)
end

# Runs application cookbooks
sudo "cp -f #{dna_path} #{dna_target}"
sudo! "cd #{config.release_path} && chef-solo -c #{config.release_path}/deploy/solo.rb -j #{dna_target}"
