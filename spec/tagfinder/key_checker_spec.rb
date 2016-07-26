RSpec.describe Tagfinder::KeyChecker do
  let(:default_keys)  { %w[splat captures] }
  let(:minimal_keys)  { default_keys + %w[data_url key] }
  let(:optional_keys) { minimal_keys + %w[params_url] }
  let(:missing_keys)  { minimal_keys - %w[data_url] }
  let(:missing_extra) { missing_keys + %w[JUNK] }
  let(:extra_keys)    { minimal_keys + %w[JUNK] }

  it 'returns true when given minimal required keys' do
    params = Hash[minimal_keys.map { |k| [k, nil] }]
    expect(described_class.call(params)).to eql [true]
  end

  it 'returns true when given minimal required + any optional keys' do
    params = Hash[optional_keys.map { |k| [k, nil] }]
    expect(described_class.call(params)).to eql [true]
  end

  it 'returns error when not given all required keys' do
    params = Hash[missing_keys.map { |k| [k, nil] }]
    expect(described_class.call(params)).to eql [
      false,
      "Provided parameters don't match expected parameters:\n" \
      "  Provided: [\"key\"]\n  Missing:  [\"data_url\"]\n\n"  \
      "  Expected: [\"data_url\", \"key\"]\n  Optional: [\"params_url\"]\n"
    ]
  end

  it 'returns error when not given all required keys + unexpected keys' do
    params = Hash[missing_extra.map { |k| [k, nil] }]
    expect(described_class.call(params)).to eql [
      false,
      "Provided parameters don't match expected parameters:\n" \
      "  Provided: [\"key\", \"JUNK\"]\n  Missing:  [\"data_url\"]\n\n"  \
      "  Expected: [\"data_url\", \"key\"]\n  Optional: [\"params_url\"]\n"
    ]
  end

  it 'returns error when not given unexpected keys' do
    params = Hash[extra_keys.map { |k| [k, nil] }]
    expect(described_class.call(params)).to eql [
      false,
      "Provided parameters don't match expected parameters:\n" \
      "  Provided: [\"data_url\", \"key\", \"JUNK\"]\n  Missing:  []\n\n"  \
      "  Expected: [\"data_url\", \"key\"]\n  Optional: [\"params_url\"]\n"
    ]
  end
end
