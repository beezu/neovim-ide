#############
#  Builder  #
#############
FROM alpine:3.17.0 AS builder

# Build dependencies
RUN apk add --no-cache --update git gcc cmake make libtool autoconf automake \
  ninja pkgconfig gettext gettext-dev musl-dev luajit g++ openssl luarocks \
  unzip libintl wget npm nodejs
# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Include Rust on PATH
ENV PATH="/root/.cargo/bin:${PATH}"
# Build Neovim from source
RUN git clone https://github.com/neovim/neovim
WORKDIR /neovim
RUN git checkout tags/v0.8.1
RUN make CMAKE_BUILD_TYPE=Release && make install
# Set up plugins lua file
RUN mkdir -p /root/.config && \
  git clone https://github.com/beezu/neovim-ide /root/.config/nvim
# Run PackerSync so it bootstraps
RUN nvim --headless -c 'PackerSync' -c 'sleep 10' -c 'qa'
# Rerun PackerSync to install remaining plugins
RUN nvim --headless -c 'PackerSync' -c 'sleep 20' -c 'qa'
# Set up TreeSitter
RUN nvim --headless -c 'TSUpdate' -c 'sleep 180' -c 'qa'
# Install LSP servers, skipping rust-analzyer if on ARM
RUN if [[ $(uname -a | awk '{ print $(NF-1) }') == aarch64 ]] ; \
  then nvim --headless -c 'MasonInstall dockerfile-language-server json-lsp \
  lua-language-server pyright yaml-language-server' -c 'sleep 30' -c 'qa' ; \
  else nvim --headless -c 'MasonInstall dockerfile-language-server json-lsp \
  lua-language-server pyright yaml-language-server rust-analzyer' -c 'sleep 30' \
  -c 'qa' ; \
  fi

###############
#  Container  #
###############
FROM alpine:3.17.0
# Apk dependencies
RUN apk add --no-cache --update fzf gettext git ripgrep npm nodejs curl && \
  mkdir /project
# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# Include Rust on PATH
ENV PATH="/root/.cargo/bin:${PATH}"
# Manually install rust-analyzer on ARM only since it fails to install via mason
RUN if [[ $(uname -a | awk '{ print $(NF-1) }') == aarch64 ]] ; \
  then rustup component add rust-analyzer && \
  ln -s $(rustup which --toolchain stable rust-analzyer) /root/.cargo/bin ; \
  fi
# Install dprint for Rust code formatting
RUN npm install -g dprint
# Set default directory where volume will be mounted
WORKDIR /project
# Copy relevant files from build environment
COPY --from=builder /root/.cargo/bin /root/.cargo/bin
COPY --from=builder /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder /usr/local/share/nvim /usr/local/share/nvim
COPY --from=builder /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=builder /usr/local/share/man/man1/nvim.1 /usr/local/share/man/man1/nvim.1
COPY --from=builder /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=builder /usr/local/share/locale /usr/local/share/locale
COPY --from=builder /usr/local/share/nvim/runtime/syntax/vim/generated.vim /usr/local/share/nvim/runtime/syntax/vim/generated.vim
COPY --from=builder /root/.config/nvim /root/.config/nvim
CMD [ "nvim" , "." ]
