# Dotfiles

This repository contains my personal system configuration files, including Zsh, Neovim, and related setup folders, used to customize and maintain a consistent development environment across machines. These files are intended for personal reference, backup, and quick re-setup, but may also be useful as a starting point for others configuring similar workflows.


## Setup tmux

I have a [dedicated video](https://youtu.be/U-omALWIBos?si=MubYcjsjwzTbCR4g) that goes in depth as to how I setup and use tmux.
It is very useful for managing sessions in the terminal as well as different windows and panes.

tmux installation:
```
brew install tmux
```

Then you’ll want to add a config for it and it should be located in `~/.tmux.conf`.
You can automatically use mine with this command:
```
curl https://raw.githubusercontent.com/josean-dev/dev-environment-files/main/.tmux.conf --output ~/.tmux.conf
```

Also install tpm (tmux plugin manager):
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Now you can start tmux by running:
```
tmux
```

Then install the plugins I use with it by pressing `CTRL-A` (my prefix) followed by `Shift-I`.
If this doesn’t work or tmux was already running, try reloading the tmux config first:
```
tmux source ~/.tmux.conf
```

Then try pressing `CTRL-A` followed by `Shift-I` again.
For the tmux theme that I’m using to work properly, you’ll probably need to install a newer version of bash:
```
brew install bash
```
Then reload the tmux configuration by doing `CTRL-A` (my prefix) followed by `r`.
