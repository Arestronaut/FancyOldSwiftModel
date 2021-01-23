class FancyOldSwiftModel < Formula
  desc "A tool to easily generate swift models"
  homepage "https://github.com/Arestronaut/FancyOldSwiftModel"
  url "https://github.com/Arestronaut/FancyOldSwiftModel.git", :tag => "1.1", :revision => "e09eb15d39aba76877ead67e1ff925dc5613a2b2"
  head "https://github.com/Arestronaut/FancyOldSwiftModel.git"

  depends_on :xcode => ["12.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "false"
  end
end
