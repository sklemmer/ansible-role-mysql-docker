# spec/features/external_request_spec.rb

## general
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

# with port
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

# with socket
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

# with socket and port
describe docker_container('maria') do
  it { should exist }
  it { should be_running }
  its('image') { should eq 'mariadb:latest' }
  its('repo') { should eq 'mariadb' }
  its('tag') { should eq 'latest' }
  its('ports') { should eq ["3306:3306"] }
end


describe mysql_conf do
  its('port') { should eq '3306' }
  its('socket') { should eq '/var/run/mysqld/mysql.sock' }
end
