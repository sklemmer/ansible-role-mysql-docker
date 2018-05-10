# spec/features/external_request_spec.rb

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

describe docker_container('mariadb') do
  it { should exist }
  it { should be_running }
  its('image') { should eq 'mariadb:latest' }
  its('repo') { should eq 'mariadb' }
  its('tag') { should eq 'latest' }
end
