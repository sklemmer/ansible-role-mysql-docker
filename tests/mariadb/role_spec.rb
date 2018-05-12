# spec/features/external_request_spec.rb

##
# general
##
control "general" do
  impact 0.7
  title "Test General Docker Config"

  describe service('docker') do
    it {should be_installed}
    it {should be_enabled}
    it {should be_running}
  end

  describe docker_image('mariadb:latest') do
    it { should exist }
    its('repo') { should eq 'mariadb'}
    its('tag') { should eq 'latest'}
  end
end

##
# plain
##
control "plain" do
  impact 0.7
  title "Test mariadb without open ports and shared socket"

  # container status
  describe docker_container('maria-plain') do
    it { should exist }
    it { should be_running }
    its('image') { should eq 'mariadb:latest' }
    its('repo') { should eq 'mariadb' }
    its('tag') { should eq 'latest' }
    its('ports') { should eq "3306/tcp" }
  end
  # conf file existence
  describe file('/etc/mysql/plain.cnf') do
    it { should exist }
    its('type') { should eq :file }
  end
  # mysql-conf check
  describe mysql_conf('/etc/mysql/plain.cnf') do
    its('client.port') { should eq '3306' }
    its('client.socket') { should eq '/var/run/mysqld/mysql.sock' }
    its('mysqld.port') { should eq '3306' }
    its('mysqld.socket') { should eq '/var/run/mysqld/mysql.sock' }
    its('mysqld_safe.socket') { should eq '/var/run/mysqld/mysql.sock' }
  end
  # data directory existence
  describe directory('/data/var/lib/mysql-plain') do
    it { should exist }
  end
end

##
# with port
##
control "with-port" do
  impact 0.7
  title "Test mariadb with open ports"

  # container status
  describe docker_container('maria-with-port') do
    it { should exist }
    it { should be_running }
    its('image') { should eq 'mariadb:latest' }
    its('repo') { should eq 'mariadb' }
    its('tag') { should eq 'latest' }
    its('ports') { should eq "0.0.0.0:3307->3306/tcp" }
  end
  # conf file existence
  describe file('/etc/mysql/with_port.cnf') do
    it { should exist }
    its('type') { should eq :file }
  end
  # mysql-conf check
  describe mysql_conf('/etc/mysql/with_port.cnf') do
    its('client.port') { should eq '3306' }
    its('client.socket') { should eq '/var/run/mysqld/mysql.sock' }
    its('mysqld.port') { should eq '3306' }
    its('mysqld.socket') { should eq '/var/run/mysqld/mysql.sock' }
    its('mysqld_safe.socket') { should eq '/var/run/mysqld/mysql.sock' }
  end
  # port existence
  describe port(3307) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
  # data directory existence
  describe directory('/data/var/lib/mysql-with-port') do
    it { should exist }
  end
end

##
# with socket
##
#control "with-socket" do
#  impact 0.7
#  title "Test mariadb with shared socket"
#
#  # container status
#  describe docker_container('maria-with-socket') do
#    it { should exist }
#    it { should be_running }
#    its('image') { should eq 'mariadb:latest' }
#    its('repo') { should eq 'mariadb' }
#    its('tag') { should eq 'latest' }
#    its('ports') { should eq "" }
#  end
#  # conf file existence
#  describe file('/etc/mysql/with_socket.cnf') do
#    it { should exist }
#    its('type') { should eq :file }
#  end
#  # mysql-conf check
#  describe mysql_conf('/etc/mysql/with_socket.cnf') do
#    its('client.port') { should eq '3306' }
#    its('client.socket') { should eq '/var/run/mysqld/mysql.sock' }
#    its('mysqld.port') { should eq '3306' }
#    its('mysqld.socket') { should eq '/var/run/mysqld/mysql.sock' }
#    its('mysqld_safe.socket') { should eq '/var/run/mysqld/mysql.sock' }
#  end
#  # socket existence
#  describe directory('/var/run/mysqld/mysql_socket/') do
#    it { should exist }
#  end
#  describe file('/var/run/mysqld/mysql_socket/mysql.sock') do
#    it { should exist }
#    its('type') { should eq :socket }
#  end
#  # data directory existence
#  describe directory('/data/var/lib/mysql-with-socket') do
#    it { should exist }
#  end
#end

##
# with socket and port
##
#control "with-socket-port" do
#  impact 0.7
#  title "Test mariadb with open ports and shared socket"
#
#  # container status
#  describe docker_container('mysql') do
#    it { should exist }
#    it { should be_running }
#    its('image') { should eq 'mariadb:latest' }
#    its('repo') { should eq 'mariadb' }
#    its('tag') { should eq 'latest' }
#    its('ports') { should eq "0.0.0.0:3308->3306/tcp" }
#  end
#  # conf file existence
#  describe file('/etc/mysql/my.cnf') do
#    it { should exist }
#    its('type') { should eq :file }
#  end
#  # mysql-conf-check
#  describe mysql_conf('/etc/mysql/my.cnf') do
#    its('client.port') { should eq '3306' }
#    its('client.socket') { should eq '/var/run/mysqld/mysql.sock' }
#    its('mysqld.port') { should eq '3306' }
#    its('mysqld.socket') { should eq '/var/run/mysqld/mysql.sock' }
#    its('mysqld_safe.socket') { should eq '/var/run/mysqld/mysql.sock' }
#  end
#  # socket existence
#  describe directory('/var/run/mysqld/socket/') do
#    it { should exist }
#  end
#  describe file('/var/run/mysqld/socket/mysql.sock') do
#    it { should exist }
#    its('type') { should eq :socket }
#  end
#  # port existence
#  describe port(3308) do
#    it { should be_listening }
#    its('protocols') { should include 'tcp' }
#  end
#  # data directory existence
#  describe directory('/data/var/lib/mysql') do
#    it { should exist }
#  end
#end
