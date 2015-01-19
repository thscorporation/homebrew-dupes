# "File" is a reserved class name
class FileFormula < Formula
  homepage "http://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.22.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.22.tar.gz"
  sha1 "20fa06592291555f2b478ea2fb70b53e9e8d1f7c"

  head "https://github.com/file/file.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/dupes"
    sha1 "0a1183e6d6f87c4982bc7a9dde8ad4f78adb4a56" => :yosemite
    sha1 "825f9273ddbc98be68bc5ce238b5456199c06db8" => :mavericks
    sha1 "be3cf9d56e3a2bde546b16b00b62cb4c71de3d04" => :mountain_lion
  end

  keg_only :provided_by_osx

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make", "install"
  end
end
