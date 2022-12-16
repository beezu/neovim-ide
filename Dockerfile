#############
#  Builder  #
#############

FROM alpine:3.17.0 AS builder
# Build dependencies
RUN apk add --no-cache --update git gcc cmake make libtool autoconf automake \
  ninja pkgconfig gettext gettext-dev musl-dev luajit g++ openssl luarocks \
  unzip libintl wget npm nodejs
# Build Neovim from source
RUN git clone https://github.com/neovim/neovim
WORKDIR /neovim
RUN git checkout tags/v0.8.1
RUN make CMAKE_BUILD_TYPE=Release && make install
# Download config
RUN mkdir -p /root/.config && \
  git clone https://github.com/beezu/neovim-ide /root/.config/nvim
# Run PackerSync so it bootstraps
RUN nvim --headless -c 'PackerSync' -c 'sleep 60' -c 'qa'
# Rerun PackerSync to install remaining plugins
RUN nvim --headless -c 'PackerSync' -c 'sleep 60' -c 'qa'
# Set up TreeSitter
RUN nvim --headless -c 'PackerSync'-c 'TSUpdate' -c 'sleep 900' -c 'qa'
# Install LSP servers, skipping rust-analzyer (manual install later)
RUN nvim --headless -c 'MasonInstall dockerfile-language-server json-lsp \
  lua-language-server pyright yaml-language-server' -c 'sleep 60' -c 'qa'

###############
#  Container  #
###############

FROM alpine:3.17.0
# Apk dependencies
ARG TARGETARCH
ARG RUSTPATH
# Runtime dependencies
RUN apk add --no-cache --update fzf gettext git ripgrep npm nodejs curl && \
  mkdir /project
# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Include Rust on PATH
ENV PATH="/root/.cargo/bin:${PATH}"
# Install dprint for Rust code formatting
RUN npm install -g dprint
# Manually install rust-analyzer
RUN rustup component add rust-analyzer
RUN case ${TARGETARCH} in \
  aarch64) RUSTPATH=stable-aarch64-unknown-linux-musl ;; \
  amd64) RUSTPATH=stable-x86_64-unknown-linux-musl ;; \
  *) exit 1 ;; \
  esac && \
  ln -s /root/.rustup/toolchains/${RUSTPATH}/bin/rust-analzyer
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
