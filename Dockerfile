ARG TZ=America/Detroit
ARG DEBIAN_FRONTEND=noninteractive

#############
#  Builder  #
#############

FROM clowa/powershell-core AS builder
SHELL ["/bin/bash", "-c"]
# Build dependencies
RUN apt-get update -qq && \
  apt-get install -qq --yes ninja-build gettext libtool libtool-bin autoconf \
  automake cmake g++ pkg-config unzip curl doxygen git nodejs npm && \
  apt-get clean -qq --yes && \
  rm -rf /var/lib/apt/lists/*
# Build Neovim from source
RUN git clone https://github.com/neovim/neovim
WORKDIR /neovim
RUN git checkout tags/v0.9.4
RUN make CMAKE_BUILD_TYPE=Release && make install
# Download config
RUN mkdir -p /root/.config && \
  git clone https://github.com/beezu/neovim-ide /root/.config/nvim
# Run PackerSync so it bootstraps
RUN nvim --headless -c 'PackerSync' -c 'sleep 40' -c 'qa'
# Rerun PackerSync to install remaining plugins
RUN nvim --headless -c 'PackerSync' -c 'sleep 40' -c 'qa'
# Set up TreeSitter
RUN nvim --headless -c 'PackerSync' -c 'TSUpdate' -c 'sleep 120' -c 'qa'
# Install LSP servers, skipping rust-analzyer (manual install later)
RUN nvim --headless -c 'MasonInstall dockerfile-language-server json-lsp \
  lua-language-server pyright yaml-language-server \
  powershell-editor-services' -c 'sleep 120' -c 'qa'

###############
#  Container  #
###############

FROM clowa/powershell-core
SHELL ["/bin/bash", "-c"]
# Apk dependencies
ARG TARGETARCH
ARG RUSTPATH
# Runtime dependencies
RUN apt-get update -qq && \
  apt-get install -qq --yes gettext git curl fzf ripgrep npm nodejs fzf \
  unzip && \
  apt-get clean -qq --yes && \
  rm -rf /var/lib/apt/lists/* && \
  mkdir /project
# RUN apk add --no-cache --update fzf gettext git ripgrep npm nodejs curl && \
#   mkdir /project
# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Include Rust on PATH
ENV PATH="/root/.cargo/bin:${PATH}"
# Install dprint for Rust code formatting
RUN curl -fsSL https://dprint.dev/install.sh | sh
# Manually install rust-analyzer
RUN rustup component add rust-analyzer
RUN case ${TARGETARCH} in \
  arm64) RUSTPATH=stable-aarch64-unknown-linux-musl ;; \
  amd64) RUSTPATH=stable-x86_64-unknown-linux-musl ;; \
  *) exit 1 ;; \
  esac && \
  ln -s /root/.rustup/toolchains/${RUSTPATH}/bin/rust-analzyer \
  /root/.cargo/bin
# Set default directory where volume will be mounted
WORKDIR /project
# Copy relevant files from build environment
COPY --from=builder /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder /usr/local/share/nvim /usr/local/share/nvim
COPY --from=builder /usr/local/bin/nvim /usr/local/bin/nvim 
COPY --from=builder /usr/local/share/locale /usr/local/share/locale 
COPY --from=builder /usr/local/lib/nvim /usr/local/lib/nvim 
COPY --from=builder /root/.config/nvim /root/.config/nvim
COPY --from=builder /usr/local/share/nvim/runtime/syntax/vim/generated.vim /usr/local/share/nvim/runtime/syntax/vim/generated.vim
COPY --from=builder /usr/local/share/man/man1/nvim.1 /usr/local/share/man/man1/nvim.1
CMD [ "nvim" , "." ]
