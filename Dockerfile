#############
#  Builder  #
#############
FROM alpine:3.17.0 AS builder

# Build dependencies
RUN apk add --no-cache --update git gcc cmake make libtool autoconf automake ninja pkgconfig gettext gettext-dev musl-dev luajit g++ openssl luarocks unzip libintl wget
# Build Neovim from source
RUN git clone https://github.com/neovim/neovim
WORKDIR /neovim
RUN git checkout tags/v0.8.1
RUN make CMAKE_BUILD_TYPE=Release && make install
# Set up plugins lua file
RUN mkdir -p /root/.config && git clone https://github.com/beezu/neovim-ide /root/.config/nvim
# Run PackerSync
RUN nvim --headless -c 'PackerSync' -c 'sleep 20' -c 'qa'
# Set up TreeSitter, giving it more than enough time to build
RUN nvim --headless -c 'TSUpdate' -c 'sleep 400' -c 'qa'

###############
#  Container  #
###############
FROM alpine:3.17.0
# App dependencies
RUN apk add --no-cache --update fzf gettext git ripgrep && mkdir /project
# Set default directory to where volume will be mounted
WORKDIR /project
# Copy relevant files from build environment
COPY --from=builder /root/.local/share/nvim /root/.local/share/nvim
COPY --from=builder /usr/local/share/nvim /usr/local/share/nvim
COPY --from=builder /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=builder /usr/local/share/man/man1/nvim.1 /usr/local/share/man/man1/nvim.1
COPY --from=builder /usr/local/lib/nvim /usr/local/lib/nvim
COPY --from=builder /usr/local/share/locale /usr/local/share/locale
COPY --from=builder /usr/local/share/nvim/runtime/syntax/vim/generated.vim /usr/local/share/nvim/runtime/syntax/vim/generated.vim
COPY --from=builder /root/.config/nvim /root/.config/nvim
CMD [ "nvim" , "." ]