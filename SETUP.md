# Fresh Install Setup Notes

## 1. Base packages
sudo pacman -S zsh base-devel github-cli

## 2. Clone dotfiles (must be at exactly ~/dotfiles — .zshrc hardcodes this path)
git clone git@github.com:evinbrijesh/dotfiles.git ~/dotfiles

## 3. Symlink configs
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
# .config subfolders: symlink individually, never the whole .config dir
# (Omarchy owns hypr/waybar/etc in there already)

## 4. Homebrew (needed for p10k, zsh-autosuggestions, zsh-syntax-highlighting)
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting

## 5. Set zsh as default shell
chsh -s /usr/bin/zsh
# IMPORTANT: logout/login is NOT enough on Hyprland/Wayland — must do a FULL REBOOT

## 6. First zsh launch
p10k configure
# Generates ~/.p10k.zsh (not tracked in repo, personal/local only)

## 7. GitHub CLI auth (sets up SSH key + git protocol automatically)
gh auth login
# choose: GitHub.com -> SSH -> generate new key -> login with browser
git remote set-url origin git@github.com:evinbrijesh/dotfiles.git

## Known gotchas
- Omarchy 4.0.1+ is a pacman package — its files live at /usr/share/omarchy/,
  NOT ~/.local/share/omarchy/ (older versions used the latter via git clone).
  zsh/functions loop path must point to /usr/share/omarchy/default/bash/fns/*(N)
  -- the (N) nullglob qualifier prevents an error if the folder's ever empty/missing.
- chsh silently fails with wrong password OR if shell isn't in /etc/shells
  (zsh usually already is on Arch, but check `cat /etc/shells` if it fails).
- Windows dual-boot on a separate SSD: if cloned/moved rather than fresh-installed,
  it may have NO EFI System Partition of its own. Check with:
  lsblk -o NAME,SIZE,PARTUUID,FSTYPE,PARTTYPENAME
  Fix via Windows recovery: diskpart shrink + create ESP + bcdboot, then
  efibootmgr -c -d /dev/nvmeXn1 -p <part#> -L "Windows Boot Manager" -l '\EFI\Microsoft\Boot\bootmgfw.efi'
  then sudo limine-scan.
