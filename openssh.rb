require "formula"

class Openssh < Formula
  homepage "http://www.openssh.com/"
  url "http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz"
  version "6.7p1"
  sha256 "b2f8394eae858dabbdef7dac10b99aec00c95462753e80342e530bbb6f725507"
  revision 1

  option "with-keychain-support", "Add native OS X Keychain and Launch Daemon support to ssh-agent"

  depends_on "autoconf" => :build if build.with? "keychain-support"
  depends_on "openssl"
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"

  if build.with? "keychain-support"
    patch do
      url "https://gist.githubusercontent.com/jbergler/ebaa38fcdda2e15f25a1/raw/ec0da92e640e2cc89f95902f20d42e0cc952195a/0002-Apple-keychain-integration-other-changes.patch"
      sha1 "ceafaee8814d4ce7477d2c75cddc7e3b209f038a"
    end
  end

  patch do
    url "https://gist.githubusercontent.com/sigkate/fca7ee9fe1cdbe77ba03/raw/6894261e7838d81c76ef4b329e77e80d5ad25afc/patch-openssl-darwin-sandbox.diff"
    sha1 "332a1831bad9f2ae0f507f7ea0aecc093829b1c4"
  end

  # Patch for SSH tunnelling issues caused by launchd changes on Yosemite
  patch do
    url "https://gist.githubusercontent.com/jbergler/c9bba580d27137a793d8/raw/4bbb60f12df413ba43af735f608cd311c4338239/launchd.patch"
    sha1 "e35731b6d0e999fb1d58362cda2574c0d1efed78"
  end

  def install
    system "autoreconf -i" if build.with? "keychain-support"

    if build.with? "keychain-support"
      ENV.append "CPPFLAGS", "-D__APPLE_LAUNCHD__ -D__APPLE_KEYCHAIN__"
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework SecurityFoundation -framework Security"
    end

    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__"

    args = %W[
      --with-libedit
      --with-pam
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-ldns" if build.with? "ldns"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.with? "keychain-support" then <<-EOS.undent
        NOTE: replacing system daemons is unsupported. Proceed at your own risk.

        For complete functionality, please modify:
          /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist

        and change ProgramArguments from
          /usr/bin/ssh-agent
        to
          #{HOMEBREW_PREFIX}/bin/ssh-agent

        You will need to restart or issue the following commands
        for the changes to take effect:

          launchctl unload /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist
          launchctl load /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist

        Finally, add  these lines somewhere to your ~/.bash_profile:
          eval $(ssh-agent)

          function cleanup {
            echo "Killing SSH-Agent"
            kill -9 $SSH_AGENT_PID
          }

          trap cleanup EXIT

        After that, you can start storing private key passwords in
        your OS X Keychain.
      EOS
    end
  end
end
