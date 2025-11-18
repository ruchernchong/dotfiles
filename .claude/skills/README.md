# Dotfiles Repository Skills

Repository-specific Claude Code skills for managing this dotfiles repository. These skills are automatically activated by Claude when working within this repository.

## Available Skills

### 1. brew-manager
Manage Homebrew packages in the Brewfile. Automatically activates when you mention packages, Brewfile, or want to install/remove software.

**Capabilities**:
- Add packages (brew, cask, mas, vscode extensions)
- Remove packages safely
- Verify packages exist before adding
- Maintain alphabetical organisation
- Search for packages

**Triggers**: "add package", "install", "Brewfile", "homebrew", "cask"

### 2. alias-manager
Manage shell aliases in the .aliases file. Automatically activates when you mention aliases or command shortcuts.

**Capabilities**:
- Add new aliases
- Remove or update existing aliases
- Check for naming conflicts
- Organise by category
- Suggest improvements

**Triggers**: "alias", "shortcut", "command abbreviation", ".aliases"

### 3. crontab-manager
Manage scheduled tasks in the crontab configuration. Automatically activates when you mention scheduling or automation.

**Capabilities**:
- Add scheduled tasks with proper cron syntax
- Remove or update cron jobs
- Validate cron syntax
- Configure logging
- Explain schedules

**Triggers**: "cron", "schedule", "automated task", "periodic job"

### 4. setup-tester
Test and validate the dotfiles setup process. Automatically activates when you want to test or troubleshoot the setup.

**Capabilities**:
- Pre-setup validation
- Test setup.sh execution
- Post-setup verification
- Symlink checking
- Troubleshoot issues

**Triggers**: "test setup", "validate", "check dotfiles", "verify installation"

### 5. git-dotfiles-helper
Help with Git operations specific to this dotfiles repository. Automatically activates for git-related tasks.

**Capabilities**:
- Generate contextual commit messages
- Review changes before committing
- Detect sensitive data
- Follow dotfiles best practices
- Suggest proper git workflow

**Triggers**: "commit", "git", "changes", "review"

### 6. sync-checker
Verify dotfiles are properly symlinked and synchronised. Automatically activates when checking system state.

**Capabilities**:
- Verify all symlinks
- Detect broken links
- Check file permissions
- Test configuration loading
- Comprehensive health check

**Triggers**: "check sync", "verify symlinks", "dotfiles status", "check setup"

### 7. documentation-updater
Keep CLAUDE.md and README.md in sync with actual configuration. Automatically activates when updating documentation.

**Capabilities**:
- Sync CLAUDE.md and README.md
- Update for configuration changes
- Verify documentation accuracy
- Maintain consistency
- Document new features

**Triggers**: "update docs", "update README", "update CLAUDE.md", "document changes"

## How Skills Work

These skills are **automatically invoked** by Claude based on context. You don't need to explicitly call them - just mention relevant topics and Claude will use the appropriate skill.

**Examples**:
- Say "add ripgrep to the Brewfile" → brew-manager activates
- Say "create an alias for git status" → alias-manager activates
- Say "check if my dotfiles are set up correctly" → sync-checker activates

## Skill Features

All skills in this repository:
- Use **British English** throughout
- Have **full access** to read and modify files
- Are **context-aware** of this dotfiles repository structure
- Provide **detailed explanations** and examples
- Follow **best practices** for dotfiles management

## Adding New Skills

To add a new skill:

1. Create a new directory: `.claude/skills/skill-name/`
2. Create `SKILL.md` with YAML frontmatter:
   ```yaml
   ---
   name: skill-name
   description: What it does and when to use it (include trigger keywords)
   ---

   # Skill Instructions

   Your detailed instructions here...
   ```
3. Commit to git for version control
4. Skill is automatically available in this repository

## Notes

- Skills are **repository-specific** - only active in this dotfiles directory
- Skills **automatically activate** - no manual invocation needed
- Skills can **read and modify** files with full access
- All skills follow **British English** conventions
