require "formula"

class Mono < Formula
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-3.2.8.tar.bz2"
  sha1 "d58403caec82af414507cefa58ce74bbb792985a"

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-master/latest/monolite-111-latest.tar.gz"
    sha1 "7f6715b8e569b6e7ad85c207311f145f688b3cf5"
  end

  def install
    # a working mono is required for the the build - monolite is enough
    # for the job
    (buildpath+"mcs/class/lib/monolite").install resource("monolite")

    args = %W[
      --prefix=#{prefix}
      --enable-nls=no
    ]
    args << "--build=" + (MacOS.prefer_64_bit? ? "x86_64": "i686") + "-apple-darwin"

    system "./configure", *args
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
    # help mono find its MonoPosixHelper lib even when mono formula is not linked
    # https://bugzilla.xamarin.com/show_bug.cgi?id=18555
    mono_config = prefix/"etc/mono/config"
    content = mono_config.read
    content['"libMonoPosixHelper.dylib"'] = "\"#{lib}/libMonoPosixHelper.dylib\""
    mono_config.atomic_write content
  end

  test do
    test_str = "Hello Homebrew"
    hello = (testpath/"hello.cs")
    hello.write <<-EOS.undent
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    `#{bin}/mcs #{hello}`
    assert $?.success?
    output = `#{bin}/mono hello.exe`
    assert $?.success?
    assert_equal test_str, output.strip
  end

  def caveats; <<-EOS.undent
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end
end
