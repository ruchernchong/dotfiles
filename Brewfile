echo "Updating Homebrew"
brew update

echo "Upgrading Homebrew installed packages"
brew upgrade

packages=(
	"github/gh/gh"
	"mas"
	"node"
	"nvm"
	"yarn"
)

echo "Installing Homebrew packages"
for package in "${packages[@]}"; do
	brew install "$package"
done

echo "Upgrading Homebrew cask apps"
brew upgrade --casks

casks=(
	"coconutbattery"
	"postman"
)

echo "Installing Homebrew cask apps"
for cask in "${casks[@]}"; do
	brew cask install "$cask"
done

echo "Installing Brew Tab Completion"
brew install brew-cask-completion

echo "Cleaning up..."

brew cleanup
