RSpec.describe Tagfinder::Shell::Command do
  it 'builds a templated command' do
    stub_const('ListFiles', Class.new(described_class))

    class ListFiles < described_class
      CMD = 'ls -trla %<dir>s'.freeze
    end

    expect(ListFiles.new(dir: 'hello').to_s).to eql('ls -trla hello')
  end
end
