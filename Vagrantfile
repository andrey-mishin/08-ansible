Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7"
  config.vm.hostname = "clickhouse"
  config.vm.network "forwarded_port", guest: 22, host: 2022, id: "ssh"
end
