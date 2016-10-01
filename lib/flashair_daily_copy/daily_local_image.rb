require 'fileutils'

module FlashairDailyCopy
  class DailyLocalImage
    def initialize(filename, datetime)
      @filename = filename
      @datetime = datetime
    end

    def filename
      "#{dir_path}/#{@filename}"
    end

    private

    def dir_path
      dir = "#{root_dir}/#{@datetime.strftime('%Y-%m-%d')}"
      unless File.exists?(dir)
        FileUtils.mkdir_p(dir)
      end
      dir
    end

    def root_dir
      ENV['FLASHAIR_LOCAL_DIR'] || '/tmp/flashair'
    end
  end
end
