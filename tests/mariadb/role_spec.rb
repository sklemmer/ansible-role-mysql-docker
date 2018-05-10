# spec/features/external_request_spec.rb

##
# general
##
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

##
# with port
##
describe docker_container('maria-with-port') do
  it { should exist }
  it { should be_running }
  its('image') { should eq 'mariadb:latest' }
  its('repo') { should eq 'mariadb' }
  its('tag') { should eq 'latest' }
  its('ports') { should eq ["3306:3306"] }
end

describe mysql_conf('/etc/mysql/with_port.cnf') do
  its('port') { should eq '3306' }
end

describe file('/etc/mysql/with_port.cnf') do
  it { should exist }
  its('type') { should eq :file }
end

describe directory('/data/var/lib/mysql-with-port') do
  it { should exist }
end

describe port(3306) do
  its('protocols') { should include 'tcp' }
end

##
# with socket
##
describe docker_container('maria-with-socket') do
  it { should exist }
  it { should be_running }
  its('image') { should eq 'mariadb:latest' }
  its('repo') { should eq 'mariadb' }
  its('tag') { should eq 'latest' }
  its('ports') { should eq [] }
end

describe mysql_conf('/etc/mysql/with_socket.cnf') do
  its('socket') { should eq '/var/run/mysqld/mysql_socket.sock' }
end

describe file('/etc/mysql/with_socket.cnf') do
  it { should exist }
  its('type') { should eq :file }
end

describe file('/var/run/mysqld/mysql_socket.sock') do
  it { should exist }
  its('type') { should eq :socket }
end

describe directory('/data/var/lib/mysql-with-socket') do
  it { should exist }
end

##
# with socket and port
##
describe docker_container('mysql') do
  it { should exist }
  it { should be_running }
  its('image') { should eq 'mariadb:latest' }
  its('repo') { should eq 'mariadb' }
  its('tag') { should eq 'latest' }
  its('ports') { should eq ["3307:3306"] }
end

describe mysql_conf('/etc/mysql/my.cnf') do
  its('port') { should eq '3306' }
  its('socket') { should eq '/var/run/mysqld/mysql.sock' }
end

describe file('/etc/mysql/my.cnf') do
  it { should exist }
  its('type') { should eq :file }
end

describe directory('/data/var/lib/mysql') do
  it { should exist }
end

describe file('/var/run/mysqld/mysql.sock') do
  it { should exist }
  its('type') { should eq :socket }
end

describe port(3307) do
  its('protocols') { should include 'tcp' }
end
