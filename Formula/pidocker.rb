class Pidocker < Formula
  desc "Run Pi inside an isolated Docker container"
  homepage "https://github.com/kaufdev/pidocker"
  url "https://github.com/kaufdev/pidocker/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "ba0c5f0e785009a031394dc59034f1393a5cbc46a9d1a36ea7c669d93864ba69"
  license "MIT"

  depends_on "docker"

  def install
    libexec.install "docker"
    bin.install "bin/pidocker"

    inreplace bin/"pidocker",
      'PIDOCKER_IMAGE="${PIDOCKER_IMAGE:-pidocker:local}"',
      "PIDOCKER_IMAGE=\"${PIDOCKER_IMAGE:-pidocker:v#{version}}\""

    inreplace bin/"pidocker",
      'PIDOCKER_DOCKER_CONTEXT="${PIDOCKER_DOCKER_CONTEXT:-${REPO_ROOT}/docker}"',
      "PIDOCKER_DOCKER_CONTEXT=\"${PIDOCKER_DOCKER_CONTEXT:-#{libexec}/docker}\""
  end

  def caveats
    <<~EOS
      Docker daemon must be running before using pidocker.

      First run will build the Docker image:
        pidocker
    EOS
  end

  test do
    system bin/"pidocker", "--help"
  end
end
