class Pidocker < Formula
  desc "Run Pi inside an isolated Docker container"
  homepage "https://github.com/kaufdev/pidocker"
  url "https://github.com/kaufdev/pidocker/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "e0f05e69294ebd927c5c7336ec1c994d802b41f47caf48d398b7640e5f456f4c"
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
