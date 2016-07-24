RSpec.describe Tagfinder::Shell do
  it 'runs a command' do
    adapter = double(described_class::Adapter)
    status  = instance_double(Process::Status)
    ls      = instance_double(described_class::Command, to_s: 'ls')
    grep    = instance_double(described_class::Command, to_s: 'grep')

    allow(adapter)
      .to receive(:execute)
      .with('ls')
      .and_return([
        instance_double(IO, read: 'ls stdin'),
        instance_double(IO, read: 'ls stdout'),
        instance_double(IO, read: 'ls stderr'),
        instance_double(Process::Waiter, value: status)
      ])

    allow(adapter)
      .to receive(:execute)
      .with('grep')
      .and_return([
        instance_double(IO, read: 'grep stdin'),
        instance_double(IO, read: 'grep stdout'),
        instance_double(IO, read: 'grep stderr'),
        instance_double(Process::Waiter, value: status)
      ])

    shell = described_class.create(adapter).run(ls).run(grep)

    first_execution, second_execution = *shell.history

    expect(first_execution.command).to be(ls)
    expect(second_execution.output).to eql(
      described_class::Output.new(
        stdout: 'grep stdout',
        stderr: 'grep stderr',
        status: status
      )
    )
  end
end
