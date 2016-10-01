require 'spec_helper'

describe FlashairDailyCopy::Api do
  let(:path) { '/DCIM/101OLYMP' }

  describe '.files' do
    let(:result)       { 'P9185137.JPG' }
    let(:api_url)      { described_class.send(:url_for_files, path) }
    let(:api_response) { 'DCIM/101OLYMP,P9185137.JPG,1037953,32,18738,45457' }
    before do
      stub_request(:get, api_url).to_return(body: api_response)
    end

    subject { described_class.files(path).first.filename }
    it 'should get expected result' do
      is_expected.to eq result
    end
  end

  describe 'datetime in CSV' do
    let(:date_val) { 18743 }
    let(:time_val) { 41029 }

    describe '.convert_datetime' do
      let(:result)   { DateTime.new(2016, 9, 23, 20, 2, 10) }
      subject { described_class.send(:convert_datetime, date_val, time_val) }

      it { is_expected.to eq result }
    end

    describe '.parse_date' do
      let(:result)   { [2016, 9, 23] }
      subject { described_class.send(:parse_date, date_val) }

      it { is_expected.to eq result }
    end

    describe '.parse_time' do
      let(:result)   { [20, 2, 10] }
      subject { described_class.send(:parse_time, time_val) }

      it { is_expected.to eq result }
    end
  end
end
