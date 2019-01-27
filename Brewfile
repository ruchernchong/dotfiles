echo "Updating Homebrew"

brew update

echo "Upgrading Homebrew installed packages"

brew upgrade

packages=(
	"mas"
	"node"
	"nvm"
	"speedtest-cli"
	"yarn"
)

echo "Installing Homebrew packages"

for package in "${packages[@]}"; do
	brew install "$package"
done

echo "Upgrading Homebrew cask apps"

brew cask upgrade

casks=(
	"coconutbattery"
	"docker"
	"font-hack-nerd-font"
	"iina"
	"postman"
)

echo "Installing Homebrew cask apps"

for cask in "${casks[@]}"; do
	brew cask install "$cask"
done

echo "Cleaning up..."

brew cleanup
