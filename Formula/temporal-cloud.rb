class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "da36e4e8161b76e65ae8ea4f4c14eb7f18473951790f3156a7ab15c54bbf8038"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-prerelease/releases/download/temporal-cloud-0.0.3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0f9330a6e466bb831e2cc8f9feb32212c8c3b81e3b8e139fe98e839eab9ed1a9"
    sha256 cellar: :any,                 x86_64_linux: "6be3f0bdda4c4b3ef59b969221e324320ec48c74895536507d4de25c809f6178"
  end

  depends_on "go" => :build
  depends_on "temporal"

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-s -w -X github.com/temporalio/cloud-cli/temporalcloudcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal-cloud"
  end

  test do
    run_output = shell_output("#{bin}/temporal-cloud --version")
    assert_match "cloud version #{version}", run_output
  end
end
