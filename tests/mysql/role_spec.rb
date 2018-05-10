# spec/features/external_request_spec.rb

describe docker_container('mariadb') do
  it { should exist }
  it { should be_running }
  its('image') { should eq 'mariadb:latest' }
  its('repo') { should eq 'mariadb' }
  its('tag') { should eq 'latest' }
end
