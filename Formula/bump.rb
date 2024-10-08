class Bump < Formula
    desc "Command line tool for versioning your Xcode projects."
    homepage "https://github.com/homerooliveira/Bump"
    url "https://github.com/homerooliveira/Bump.git", :tag => "2.0.0"
    version "2.0.0"
    
    depends_on :xcode => ["11.0", :build]
    
    def install
        system "make", "install", "prefix=#{prefix}"
    end
end
