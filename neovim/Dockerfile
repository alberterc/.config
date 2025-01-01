# @author alberterc

# Alpine Edge image as base
FROM alpine:edge

# Update repositories and install softwares
RUN apk add --update
RUN apk add zsh make gcc ripgrep unzip git xclip neovim curl wget gzip fd

# Install fnm for node version manager
RUN curl -fsSL https://fnm.vercel.app/install
# Run command to also install latest node and npm?

# Copy nvim config files
RUN mkdir ./setuptmp
RUN mkdir ./root/.config
RUN mkdir ./root/.config/nvim
RUN git clone https://github.com/alberterc/neovim-aerc.git ./setuptmp
RUN cp ./setuptmp/init.lua ./root/.config/nvim
RUN rm -rf ./setuptmp

# Prevent container from exit
CMD ["tail", "-f", "/dev/null"]
