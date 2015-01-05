require "formula"

class Whois < Formula
  homepage "https://packages.debian.org/sid/whois"
  url "http://ftp.us.debian.org/debian/pool/main/w/whois/whois_5.2.3.tar.xz"
  sha1 "6e9738e5b181ed600567d2ddb3b5e872d08201f0"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/dupes"
    cellar :any
    sha1 "5d87f8328466ed9b9b8a59e1486c26b58d7da45d" => :yosemite
    sha1 "8c22dda5e3bc601d26c933254b5d97b8f90db3c4" => :mavericks
    sha1 "4134fa42e1410fad594e688079ee59f679f4f429" => :mountain_lion
  end

  def install
    # autodie was not shipped with the system perl 5.8
    inreplace "make_version_h.pl", "use autodie;", "" if MacOS.version < :snow_leopard

    system "make HAVE_ICONV=1 whois_LDADD+=-liconv whois"
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois --version"
  end
end
