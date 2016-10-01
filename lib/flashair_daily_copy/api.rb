# require o'open-uri'
require 'httpclient'
require 'csv'
require 'hashie'

module FlashairDailyCopy
  class Api
    class << self
      def files(path)
        [].tap do |list|
          csv = get_csv(url_for_files(path))
          CSV.parse(csv).each do |row|
            list.push fileinfo_with row if row.count == 6
          end
        end
      end

      private

      def get_csv(api_url)
        HTTPClient.new.get_content(api_url)
      end

      def hostname
        ENV['FLASHAIR_HOSTNAME'] || 'myflashair.local'
      end

      def url_for_files(path)
        "http://#{hostname}/command.cgi?op=100&DIR=#{path}"
      end

      def fileinfo_with(row)
        h = {
          directory: row[0],
          filename:  row[1],
          size:      row[2],
          attribute: convert_attribute(row[3]),
          datetime:  convert_datetime(row[4], row[5]),
          url:       "http://#{hostname}#{row[0]}/#{row[1]}"
        }
        Hashie::Mash.new(h)
      end

      def convert_attribute(val)
        # TODO: 属性は必要無さそうなので実装を省略
        val
      end

      def convert_datetime(date_val, time_val)
        year, mon, day = parse_date(date_val)
        hour, min, sec = parse_time(time_val)

        DateTime.new(year, mon, day, hour, min, sec)
      end

      def parse_date(date_val)
        binary_num = date_val.to_i.to_s(2)
        day  = binary_num.slice!(-5, 5).to_i(2)
        mon  = binary_num.slice!(-4, 4).to_i(2)
        year = binary_num.to_i(2) + 1980
        [year, mon, day]
      end

      def parse_time(time_val)
        binary_num = time_val.to_i.to_s(2)
        sec  = binary_num.slice!(-5, 5).to_i(2) * 2
        min  = binary_num.slice!(-6, 6).to_i(2)
        hour = binary_num.to_i(2)
        [hour, min, sec]
      end
    end
  end
end
