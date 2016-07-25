RSpec.describe Tagfinder::Shell::Command do
  it 'builds a templated command' do
    stub_const('ListFiles', Class.new(described_class))

    class ListFiles < described_class
      CMD = 'ls -trla %<dir>s'.freeze
    end

    expect(ListFiles.call(dir: 'hello')).to eql('ls -trla hello')
  end
end

RSpec.describe Tagfinder::Shell::TagfinderMac do
  let(:data_file)   { 'path/to/data.mzXML' }
  let(:params_file) { 'path/to/config' }

  it 'builds a tagfinder-mac command given just a data file' do
    expect(described_class.call(data_filepath: data_file, params_filepath: nil))
      .to eql "bin/tagfinder-mac #{data_file}"
  end

  it 'builds a tagfinder-mac command given a data file & a config file' do
    expect(described_class.call(data_filepath: data_file, params_filepath: params_file))
      .to eql "bin/tagfinder-mac #{data_file} #{params_file}"
  end
end

RSpec.describe Tagfinder::Shell::TagfinderUbuntu do
  let(:data_file)   { 'path/to/data.mzXML' }
  let(:params_file) { 'path/to/config' }

  it 'builds a tagfinder command given just a data file' do
    expect(described_class.call(data_filepath: data_file, params_filepath: nil))
      .to eql "bin/tagfinder #{data_file}"
  end

  it 'builds a tagfinder command given a data file & a config file' do
    expect(described_class.call(data_filepath: data_file, params_filepath: params_file))
      .to eql "bin/tagfinder #{data_file} #{params_file}"
  end
end

RSpec.describe Tagfinder::Shell::Echo do
  let(:msg) { 'hello' }

  it 'builds a templated command' do
    expect(described_class.new(msg: msg).to_s).to eql(%Q{echo "#{msg}"})
  end
end
