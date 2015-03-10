require 'formula'

class Glances < Formula
  homepage 'https://github.com/nicolargo/glances'
  url 'https://github.com/nicolargo/glances/archive/v2.3.tar.gz'
  version '2.3'
  sha1 '55d48e356f7ff956e77890f7cc756299892f651b'

  depends_on "psutil"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/glances", "-h"
  end
end
