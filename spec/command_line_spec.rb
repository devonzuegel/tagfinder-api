RSpec.describe Tagfinder::CommandLine do
  it 'runs a command' do
    stub_const('MyCommandLine', Class.new(described_class))
    stub_const('ListFiles', Class.new(Tagfinder::Shell::Command))

    class ListFiles
      CMD = 'ls -1 %<dir>s'.freeze
    end

    class MyCommandLine < described_class
      command :ls, ListFiles
    end

    blank_shell        = instance_double(Tagfinder::Shell)
    shell_with_history = instance_double(Tagfinder::Shell)
    command_line       = MyCommandLine.new(blank_shell)

    allow(blank_shell)
      .to receive(:run)
      .with('ls -1 foo')
      .and_return(shell_with_history)

    expect(command_line.ls(dir: 'foo'))
      .to eql(MyCommandLine.new(shell_with_history))
  end
end
