Vagrant.configure(2) do |config|
    config.vm.define "clickhouse" do |clickhouse|
    clickhouse.vm.box = "bento/centos-7"
    clickhouse.vm.hostname = "clickhouse"
    clickhouse.vm.network "forwarded_port", guest: 22, host: 2022, id: "ssh"
  end
    config.vm.define "vector" do |vector|
    vector.vm.box = "bento/centos-7"
    vector.vm.hostname = "vector"
    vector.vm.network "forwarded_port", guest: 22, host: 2122, id: "ssh"
  end
end
