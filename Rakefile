# For Bundler.with_clean_env
require 'bundler/setup'

PACKAGE_NAME = "traveling-jekyll"
PACKAGE_VERSION = "3.4.3"
TRAVELING_RUBY_VERSION = "20150210-2.2.0"
FFI_VERSION = "1.9.6"

desc "Package your app"
task :package => ['package:linux:x86', 'package:linux:x86_64', 'package:osx']

namespace :package do
  namespace :linux do
    desc "Package your app for Linux x86"
    task :x86 => [:bundle_install,
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz",
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-ffi-#{FFI_VERSION}.tar.gz"
    ] do
      create_package("linux-x86")
    end

    desc "Package your app for Linux x86_64"
    task :x86_64 => [:bundle_install,
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz",
      "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-ffi-#{FFI_VERSION}.tar.gz"
    ] do
      create_package("linux-x86_64")
    end
  end

  desc "Package your app for OS X"
  task :osx => [:bundle_install,
    "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz",
    "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-ffi-#{FFI_VERSION}.tar.gz"
  ] do
    create_package("osx")
  end

  desc "Install gems to local directory"
  task :bundle_install do
    if RUBY_VERSION !~ /^2\.2\./
      abort "You can only 'bundle install' using Ruby 2.2, because that's what Traveling Ruby uses."
    end
    sh "rm -rf packaging/tmp"
    sh "mkdir packaging/tmp"
    sh "cp Gemfile Gemfile.lock packaging/tmp/"
    Bundler.with_clean_env do
      sh "cd packaging/tmp && env BUNDLE_IGNORE_CONFIG=1 bundle install --path ../vendor --without development"
    end
    sh "rm -rf packaging/tmp"
    sh "rm -f packaging/vendor/*/*/cache/*"
    sh "rm -rf packaging/vendor/ruby/*/extensions"
    sh "find packaging/vendor/ruby/*/gems -name '*.so' | xargs rm -f"
    sh "find packaging/vendor/ruby/*/gems -name '*.bundle' | xargs rm -f"
    sh "find packaging/vendor/ruby/*/gems -name '*.o' | xargs rm -f"
  end
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86.tar.gz" do
  download_runtime("linux-x86")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64.tar.gz" do
  download_runtime("linux-x86_64")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx.tar.gz" do
  download_runtime("osx")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86-ffi-#{FFI_VERSION}.tar.gz" do
  download_native_extension("linux-x86", "ffi-#{FFI_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-linux-x86_64-ffi-#{FFI_VERSION}.tar.gz" do
  download_native_extension("linux-x86_64", "ffi-#{FFI_VERSION}")
end

file "packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-osx-ffi-#{FFI_VERSION}.tar.gz" do
  download_native_extension("osx", "ffi-#{FFI_VERSION}")
end

def create_package(target)
  package_dir = "#{PACKAGE_NAME}-#{PACKAGE_VERSION}-#{target}"
  sh "rm -rf #{package_dir}"
  sh "mkdir #{package_dir}"
  sh "mkdir -p #{package_dir}/lib/app"
  sh "cp jekyll.rb #{package_dir}/lib/app/"
  sh "mkdir #{package_dir}/lib/ruby"
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz -C #{package_dir}/lib/ruby"
  sh "cp packaging/wrapper.sh #{package_dir}/jekyll"
  sh "chmod +x #{package_dir}/jekyll"
  sh "cp -pR packaging/vendor #{package_dir}/lib/"
  sh "cp Gemfile Gemfile.lock #{package_dir}/lib/vendor/"
  sh "mkdir #{package_dir}/lib/vendor/.bundle"
  sh "cp packaging/bundler-config #{package_dir}/lib/vendor/.bundle/config"
  sh "tar -xzf packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-ffi-#{FFI_VERSION}.tar.gz " +
   "-C #{package_dir}/lib/vendor/ruby"

  # Hack to get paths containing spaces to behave correctly
  # @see https://github.com/phusion/traveling-ruby/issues/38

  sh %Q{sed -i '' -e 's|RUBYOPT=\\\\"-r$ROOT/lib/restore_environment\\\\"|RUBYOPT=\\\\"-rrestore_environment\\\\"|' #{package_dir}/lib/ruby/bin/ruby_environment}
  sh %Q{sed -i '' -e 's|GEM_HOME="$ROOT/lib/ruby/gems/2.2.0"|GEM_HOME=\\\\"$ROOT/lib/ruby/gems/2.2.0\\\\"|' #{package_dir}/lib/ruby/bin/ruby_environment}
  sh %Q{sed -i '' -e 's|GEM_PATH="$ROOT/lib/ruby/gems/2.2.0"|GEM_PATH=\\\\"$ROOT/lib/ruby/gems/2.2.0\\\\"|' #{package_dir}/lib/ruby/bin/ruby_environment}
  sh "mv #{package_dir}/lib/ruby/lib/restore_environment.rb #{package_dir}/lib/ruby/lib/ruby/2.2.0/restore_environment.rb"

  sh "tar -czf #{package_dir}.tar.gz #{package_dir}"
  sh "rm -rf #{package_dir}"
end

def download_runtime(target)
  sh "cd packaging && curl -L -O --fail " +
    "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}.tar.gz"
end

def download_native_extension(target, gem_name_and_version)
  sh "curl -L --fail -o packaging/traveling-ruby-#{TRAVELING_RUBY_VERSION}-#{target}-#{gem_name_and_version}.tar.gz " +
    "https://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-gems-#{TRAVELING_RUBY_VERSION}-#{target}/#{gem_name_and_version}.tar.gz"
end
