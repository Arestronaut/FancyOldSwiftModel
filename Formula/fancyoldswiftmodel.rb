class FancyOldSwiftModel < Formula
  desc "A tool to easily generate swift models"
  homepage "https://github.com/Arestronaut/FancyOldSwiftModel"
  url "https://github.com/Arestronaut/FancyOldSwiftModel.git", :tag => "1.0", :revision => "4447baf57c8aba26d9443f93d328fb872bdfe62b"
  head "https://github.com/Arestronaut/FancyOldSwiftModel.git"

  depends_on :xcode => ["12.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "false"
  end
end