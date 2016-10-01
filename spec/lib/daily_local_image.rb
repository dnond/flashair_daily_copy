require 'spec_helper'

describe FlashairDailyCopy::DailyLocalImage do
  let(:filename)    { 'P10000.JPG' }
  let(:datetime)    { DateTime.now }
  let(:local_image) { described_class.new(filename, datetime) }

  describe '#filename' do
    let(:dir_path) { '/tmp/flashair/2016-09-24' }
    let(:result)    { "#{dir_path}/#{filename}" }
    before do
      allow(local_image).to receive(:dir_path).and_return(dir_path)
    end

    subject { local_image.filename }
    it { is_expected.to eq result }
  end

  describe '#dir_path' do
    let(:root_dir) { '/tmp/flashair' }
    let(:result)   { "#{root_dir}/#{datetime.strftime('%Y-%m-%d')}" }
    before do
      allow(described_class).to receive(:root_dir).and_return(root_dir)
    end

    subject { local_image.send(:dir_path) }
    it { is_expected.to eq result }

    describe 'call mkdir_p' do
      before do
        allow(File).to receive(:exists?).and_return(false)
      end

      it 'should call mkdir_p when dir not exists' do
        expect(FileUtils).to receive(:mkdir_p).with(result)
        subject
      end
    end
  end
end
