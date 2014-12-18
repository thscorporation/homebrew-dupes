require 'formula'

# "File" is a reserved class name
class FileFormula < Formula
  homepage 'http://www.darwinsys.com/file/'
  url 'ftp://ftp.astron.com/pub/file/file-5.21.tar.gz'
  mirror 'http://fossies.org/unix/misc/file-5.21.tar.gz'
  sha1 '9836603b75dde99664364b0e7a8b5492461ac0fe'

  head 'https://github.com/glensc/file.git'

  keg_only :provided_by_osx

  # Patch applied upstream, should be in 5.22
  # See http://bugs.gw.com/view.php?id=230
  patch do
    url "https://github.com/file/file/commit/f79e16aebe701fdb8e821c3c1f3504568d0c10f5.diff"
    sha1 "7dcbf309bf013c11a6c5367bab8834050d762bd5"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5"
    system "make install"
  end
end
