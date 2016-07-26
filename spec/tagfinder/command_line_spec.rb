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

  describe 'cli.tagfinder' do
    let(:cli) { Sinatra::Base.development? ? Tagfinder::MacCLI.new : Tagfinder::UbuntuCLI.new }

    let(:no_files) do
      {
        command: 'bin/tagfinder-mac',
        status:  0,
        stderr:  '',
        stdout:  File.read(Pathname.new('spec').join('fixtures', 'tagfinder-usage.txt'))
      }
    end

    let(:non_mzxml_file) do
      no_files.merge(
        command: 'bin/tagfinder-mac badfile',
        stderr:  "File name did not end in \".mzxml\".\n"
      )
    end

    let(:bad_mzxml_file) do
      {
        command: 'bin/tagfinder-mac badfile.mzxml',
        status:  1,
        stderr:  "error declared in file [main.cpp] at line 317\nfailed to load mzxml file\n",
        stdout:  File.read(Pathname.new('spec').join('fixtures', 'tagfinder-bad-file.txt'))
      }
    end

    it 'provides usage information when not provided any files' do
      history = cli.tagfinder(data_filepath: nil, params_filepath: nil).history
      expect(history.to_a.first.to_s).to eql(no_files)
    end

    it 'tells user to provide an .mzxml file' do
      history = cli.tagfinder(data_filepath: 'badfile', params_filepath: nil).history
      expect(history.to_a.first.to_s).to eql(non_mzxml_file)
    end

    it 'tells ' do
      history = cli.tagfinder(data_filepath: 'badfile.mzxml', params_filepath: nil).history
      expect(history.to_a.first.to_s).to eql(bad_mzxml_file)
    end
  end
end
