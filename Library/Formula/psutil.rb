require 'formula'

class Psutil < Formula
  homepage 'https://github.com/giampaolo/psutil'
  url 'https://github.com/giampaolo/psutil/archive/release-2.2.1.tar.gz'
  version '2.2.1'
  sha1 'd429096c9d0f6221152720f6b84a10b4a63087b3'

  depends_on "psutils"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "/bin/echo ", "foooooo"
  end
end
