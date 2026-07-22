class Pidocker < Formula
  desc "Run Pi inside an isolated Docker container"
  homepage "https://github.com/kaufdev/pidocker"
  url "https://github.com/kaufdev/pidocker/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "09011693adc42aaf28ee46ad1bec7a18a6aaaca2b2104cb3ef946a960f314e13"
  license "MIT"

  depends_on "docker"

  def install
    cp "README.md", "docker/README.md"
    inreplace "docker/Dockerfile",
      "COPY docker/pidocker-ssh-setup", "COPY pidocker-ssh-setup"
    inreplace "docker/Dockerfile",
      "COPY docker/pidocker-resume-repo.ts", "COPY pidocker-resume-repo.ts"
    inreplace "docker/Dockerfile",
      "COPY docker/pidocker-bootstrap.cjs", "COPY pidocker-bootstrap.cjs"
    inreplace "docker/Dockerfile",
      "COPY docker/pidocker-AGENTS.md", "COPY pidocker-AGENTS.md"

    libexec.install "docker"
    bin.install "bin/pidocker"

    inreplace bin/"pidocker",
      'PIDOCKER_IMAGE="${PIDOCKER_IMAGE:-pidocker:local}"',
      "PIDOCKER_IMAGE=\"${PIDOCKER_IMAGE:-pidocker:v#{version}}\""
    inreplace bin/"pidocker",
      'PIDOCKER_DOCKER_CONTEXT="${PIDOCKER_DOCKER_CONTEXT:-${REPO_ROOT}}"',
      "PIDOCKER_DOCKER_CONTEXT=\"${PIDOCKER_DOCKER_CONTEXT:-#{libexec}/docker}\""
    inreplace bin/"pidocker",
      'PIDOCKER_DOCKERFILE="${PIDOCKER_DOCKERFILE:-${PIDOCKER_DOCKER_CONTEXT}/docker/Dockerfile}"',
      "PIDOCKER_DOCKERFILE=\"${PIDOCKER_DOCKERFILE:-#{libexec}/docker/Dockerfile}\""
    inreplace bin/"pidocker",
      "node /usr/local/share/pidocker/pidocker-bootstrap.cjs",
      "node #{libexec}/docker/pidocker-bootstrap.cjs"
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
