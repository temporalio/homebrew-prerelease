class TemporalCloud < Formula
  desc "Cloud plugin for the Temporal CLI (Pre-release)"
  homepage "https://github.com/temporalio/cloud-cli"

  url "https://github.com/temporalio/cloud-cli/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "69b258270c1988a181510b17afaf3d0b502ee9d7cfddfe880383e19e292d1f93"
  license "MIT"
  head "https://github.com/temporalio/cloud-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/temporalio/homebrew-prerelease/releases/download/temporal-cloud-0.0.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e5020d3d37a77b437b1f0bfae31514517a592a790b226d7e3e75913cffed0d9a"
    sha256 cellar: :any,                 x86_64_linux: "cec56424889857c916b4c1125aa285ee134b1e3dfd6f7fc63de44172e11bf33f"
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
