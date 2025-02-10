FROM ubuntu:jammy as builder

USER 0

# Install Spack requirements
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    coreutils \
    curl \
    environment-modules \
    gfortran \
    git \
    gpg \
    lsb-release \
    python3 \
    python3-distutils \
    python3-venv \
    unzip \
    zip \
&& rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash gymusr
USER gymusr
WORKDIR /home/gymusr
ENV BASH_ENV=/etc/profile
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-c"]

# 1. Get and enable Spack (version 0.19.0, last stable when writing this recipe)
RUN git clone --branch v0.19.0 -c feature.manyFiles=true https://github.com/spack/spack.git
RUN git clone https://github.com/pdidev/spack.git spack/var/spack/repos/pdi
RUN git clone https://gitlab.inria.fr/rgautron/gym_dssat_pdi-spack.git spack/var/spack/repos/gym-dssat-pdi



RUN . spack/share/spack/setup-env.sh \
&& spack repo add spack/var/spack/repos/pdi \
&& spack repo add spack/var/spack/repos/gym-dssat-pdi \
&& spack install gym-dssat \
&& spack env create gym-dssat-pdi spack/var/spack/repos/gym-dssat-pdi/env/spack.yaml \
&& spack env activate gym-dssat-pdi \
&& spack concretize

CMD [". spack/share/spack/setup-env.sh && spack env activate gym-dssat-pdi && python spack/gym-dssat-pdi/samples/run_env.py"]

### Build the Docker image
# docker build . -t "gym-dssat:jammy-spack" -f Dockerfile_Ubuntu_Jammy_Spack
#
### Run the default example in the Docker image:
# docker run gym-dssat:jammy-spack
#
### Interactively run the gym-dssat-pdi environment in the Docker image:
# docker run -it gym-dssat:jammy-spack bash
# ~$ source spack/share/spack/setup-env.sh
# ~$ spack env activate gym-dssat-pdi
# ~$ python spack/gym-dssat-pdi/samples/run_env.py