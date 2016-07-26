RSpec.describe Tagfinder::Execution::ResultsUploader do
  let(:dir)              { Pathname.new('dir') }
  let(:data_filepath)    { dir.join('datafile.txt') }
  let(:results_uploader) { described_class.new(data_filepath) }

  describe '#filenames' do
    it 'returns local filepaths of results associated with :data_filepath' do
      expect(results_uploader.filepaths).to eql [
        dir.join('datafile_chart.txt'),
        dir.join('datafile_filter_log.txt'),
        dir.join('datafile_filter_log2.txt'),
        dir.join('datafile_filtered.mzxml'),
        dir.join('datafile_massspec.csv'),
        dir.join('datafile_summary.txt')
      ]
    end
  end

  describe '#urls' do
    it 'returns results urls once results files have been uploaded' do
      skip
      expect(results_uploader.urls).to eql [] # TODO
      # - check individuall that each file is uploaded
    end
  end
end
