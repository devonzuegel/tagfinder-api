RSpec.describe Tagfinder::Shell::Adapter do
  it 'runs command with Open3' do
    adapter = described_class.new
    output  = instance_double(Open3)

    allow(Open3)
      .to receive(:popen3)
      .with('echo "hi"')
      .and_return(output)

    expect(adapter.execute('echo "hi"')).to be(output)
  end
end
