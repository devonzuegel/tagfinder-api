RSpec.describe Tagfinder::Shell do
  let(:adapter)     { double(described_class::Adapter) }
  let(:status)      { instance_double(Process::Status) }
  let(:process)     { instance_double(Process::Waiter, value: status) }
  let(:ls)          { instance_double(described_class::Command, to_s: 'ls') }
  let(:grep)        { instance_double(described_class::Command, to_s: 'grep') }
  let(:ls_output)   { ['ls stdout', 'ls stderr', process] }
  let(:grep_output) { ['grep stdout', 'grep stderr', process] }

  before do
    allow(adapter).to receive(:execute).with('ls').and_return(ls_output)
    allow(adapter).to receive(:execute).with('grep').and_return(grep_output)
  end

  it 'runs a command' do
    shell = described_class.create(adapter).run(ls).run(grep)

    first_execution, second_execution = *shell.history

    expect(first_execution.command).to be(ls)
    expect(first_execution.output).to eql(
      described_class::Output.new(
        stdout: 'ls stdout',
        stderr: 'ls stderr',
        status: status
      )
    )

    expect(second_execution.command).to be(grep)
    expect(second_execution.output).to eql(
      described_class::Output.new(
        stdout: 'grep stdout',
        stderr: 'grep stderr',
        status: status
      )
    )
  end
end
