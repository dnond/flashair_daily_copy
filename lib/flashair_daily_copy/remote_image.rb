module FlashairDailyCopy
  class RemoteImage
    def initialize(url)
      @url = url
    end

    def download(local_path)
      open(local_path, "wb") do |f|
        f.write open(@url).read
      end
    end
  end
end
