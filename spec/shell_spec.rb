RSpec.describe Tagfinder::Shell do
  let(:shell)         { described_class.new }
  let(:talking_shell) { described_class.new(logger: true) }

  describe '.new' do
    it 'should be initialized with empty results strings' do
      expect(shell.commands).to eq []
      expect(shell.stdouts).to  eq []
      expect(shell.stderrs).to  eq []
    end
  end

  describe '#run' do
    let(:str) { 'hello there!' }
    let(:cmd) { "echo #{str};" }

    it 'should save the output of a command run' do
      shell.run(cmd)
      expect(shell.stdouts).to  eq ["#{str}\n"]
      expect(shell.commands).to eq [cmd]
    end

    it 'logs nothing to stdout by default' do
      expect { shell.run(cmd) }.to output('').to_stdout
      expect { shell.run(cmd) }.to output('').to_stderr
    end

    it 'logs output to stdout when logger=true' do
      expect { talking_shell.run(cmd) }.to output("\e[0;92;49m#{str}\n\e[0m").to_stdout
      expect { talking_shell.run(cmd) }.to output('').to_stderr
    end

    it 'should not add stderrs for a non-erroring command run' do
      str = 'hello there!'
      shell.run("echo #{str};")
      expect(shell.stderrs).to eq ['']
    end

    it 'should save the stderrs of an erroring command run' do
      shell.run('print hi;')
      expect(shell.stderrs).to eq ["sh: print: command not found\n"]
    end

    it 'should append the output of multiple runs' do
      strs = %w[hi hola hallo]
      cmds = strs.map { |s| "echo #{s};" }
      cmds.each { |cmd| shell.run(cmd) }
      expect(shell.commands).to eq cmds
      expect(shell.stdouts).to eq strs.map { |s| "#{s}\n" }
      expect(shell.stderrs).to eq strs.map { '' }
    end

    it 'should append the stderrs of multiple runs' do
      cmds = [
        'echo blah;',
        'print hello!;',
        'echo blah;'
      ]

      cmds.each { |cmd| shell.run(cmd) }
      expect(shell.stderrs).to eq [
        '',
        "sh: print: command not found\n",
        ''
      ]
    end

    it 'should require commands to end with semicolons' do
      expect { shell.run('echo hi') }
        .to raise_error ArgumentError, 'Please end all commands with a semi-colon'
    end
  end

  describe '#add_output' do
    let(:output_str) { 'some output' }

    it 'adds output to object' do
      expect { shell.add_output(output_str) }
        .to change { shell.stdouts }
        .from([]).to([output_str])
    end

    it 'prints output & adds it to object' do
      expect { talking_shell.add_output(output_str) }
        .to output("\e[0;92;49m#{output_str}\e[0m").to_stdout
    end

    it 'adds error to object' do
      expect { shell.add_error(output_str) }
        .to change { shell.stderrs }
        .from([]).to([output_str])
    end

    it 'prints error & adds it to object' do
      expect { talking_shell.add_error(output_str) }
        .to output("\e[0;33;49m#{output_str}\e[0m").to_stdout
    end
  end
end
