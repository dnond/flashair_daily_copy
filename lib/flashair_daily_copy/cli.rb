require 'thor'

module FlashairDailyCopy
  class CLI < ::Thor

    desc 'run', 'execute download from flashair'
    def self.run
      # TODO: 他のディレクトリも読めるようにする
      path = '/DCIM/101OLYMP'
      Api.files(path).each do |file|
        daily_local_image = DailyLocalImage.new(file.filename, file.datetime).filename

        unless File.exists? daily_local_image
          RemoteImage.new(file.url).download(daily_local_image)
        end
      end
    end
  end
end
