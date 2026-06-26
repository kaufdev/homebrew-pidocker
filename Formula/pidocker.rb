class Pidocker < Formula
  desc "Run Pi inside an isolated Docker container"
  homepage "https://github.com/kaufdev/pidocker"
  url "https://github.com/kaufdev/pidocker/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "0004e70e421dec78102f5d7adc3cc3e9c5c3f96abf4f3408066ac558640d7d03"
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
