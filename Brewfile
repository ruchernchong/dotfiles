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

echo "Installing Brew Tab Completion"
brew install brew-cask-completion

echo "Cleaning up..."

brew cleanup
