class Gzip < Formula
  homepage "https://www.gnu.org/software/gzip"
  url "http://ftpmirror.gnu.org/gzip/gzip-1.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gzip/gzip-1.6.tar.gz"
  mirror "http://mirror.clarkson.edu/gnu/gzip/gzip-1.6.tar.gz"
  sha1 "7ec6403090b3eaeb53ef017223cb8034eebc1f49"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/dupes"
    cellar :any
    sha1 "80aff7ae695f8f7ed1b4a7a68566cd7e0fac6fa4" => :yosemite
    sha1 "d5d9891b8f1afea7c3d5288314f5bc3f6cb2a0af" => :mavericks
    sha1 "6c75eee3fb519f841177abae22bb4a3e30d237c9" => :mountain_lion
  end

  # Add support for --rsyncable option
  patch do
    url "http://cvs.pld-linux.org/cgi-bin/viewvc.cgi/cvs/packages/gzip/gzip-rsyncable.patch?revision=1.4&view=co"
    sha1 "e59c60fcb8a70a8ef2884a624e439b0b6d9b5ace"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
