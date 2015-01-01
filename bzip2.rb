require "formula"

class Bzip2 < Formula
  homepage "http://www.bzip.org/"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  sha1 "3f89f861209ce81a6bab1fd1998c0ef311712002"

  keg_only :provided_by_osx

  def install
    system "make", "install", "PREFIX=#{prefix}"
    mkdir_p man
    mv "#{prefix}/man", man
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/bzip2", testfilepath
    system "#{bin}/bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
