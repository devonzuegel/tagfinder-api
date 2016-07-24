RSpec.describe Tagfinder::Shell::Command::Echo do
  let(:msg) { 'hello' }

  it 'builds a templated command' do
    expect(described_class.new(msg: msg).to_s).to eql(%Q{echo "#{msg}"})
  end
end
