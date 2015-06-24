require 'rspec/given'
require 'spec_helper'
require 'cli'

describe CLI, '#cli' do
  Given(:conf) { CLI::Args }

  it 'should return default config' do
    expect(conf['essential_topics'].length).to eq 0
  end

  it 'should have a map for health_reporting' do
    expect(conf['health_reporting']['enabled']).to eq true
  end

  it 'should have a map for error_reporting' do
    expect(conf['error_reporting']['enabled']).to eq true
  end

  it 'should have a map for HTTP listening variables' do
    expect(conf['listen_to']['host']).not_to be_empty
    expect(conf['listen_to']['port']).to be > 8000
  end
end
