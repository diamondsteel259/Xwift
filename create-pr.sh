#!/bin/bash
# Script to create pull request for README.md update

echo "Creating pull request to merge README.md updates into master branch..."

# PR details
TITLE="docs: Update README.md with Xwift branding"
BODY="## Summary
- Replaced original Monero documentation with Xwift-specific content
- Updated project title from \"Monero\" to \"Xwift\"
- Added \"Key Differences from Monero\" section highlighting 30-second blocks, unique network ID, custom ports, and development fund
- Updated all references from Monero binaries (monerod, monero-wallet-cli) to Xwift binaries (xwiftd, xwift-wallet-cli, xwift-wallet-rpc)
- Removed Monero donation addresses and community links
- Maintained technical accuracy for build instructions and dependencies
- Added proper attribution to Monero Project as upstream
- Linked to README_XWIFT.md for detailed deployment guide

## Changes Made
- **Title**: Changed from \"# Monero\" to \"# Xwift\"
- **Copyright**: Added Xwift Project copyright, kept Monero attribution
- **Introduction**: Explained Xwift as Monero fork with unique parameters
- **Network Configuration**: Documented mainnet (19080/19081/19082) and testnet (29080/29081/29082) ports
- **Quick Start**: Added reference to README_XWIFT.md and deployment script
- **Binary Names**: Updated all references to use xwiftd, xwift-wallet-cli, xwift-wallet-rpc
- **Acknowledgments**: Added section crediting Monero Project and CryptoNote developers
- **License**: Maintained BSD-3-Clause compatibility with proper attribution

## Testing
- README.md renders correctly with proper markdown formatting
- All internal links reference correct sections
- Technical build instructions remain accurate
- No Monero donation addresses or external Monero links remain

## Rationale
The main README.md is the first thing users see on GitHub. Having it still reference Monero would confuse users and misrepresent the Xwift project. This update ensures the documentation accurately reflects the Xwift blockchain while properly acknowledging the upstream Monero project.

This completes the final documentation issue identified in the code review. The fork implementation is now production-ready with proper branding throughout."

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo ""
    echo "You can create the PR manually by visiting:"
    echo "https://github.com/diamondsteel259/Xwift/compare/master...compyle/fork-code-review"
    echo ""
    echo "Or install GitHub CLI from: https://cli.github.com/"
    exit 1
fi

# Create the PR
gh pr create --title "$TITLE" --body "$BODY" --base master --head compyle/fork-code-review

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Pull request created successfully!"
    echo ""
    gh pr view
else
    echo ""
    echo "Failed to create pull request automatically."
    echo "Please create it manually at:"
    echo "https://github.com/diamondsteel259/Xwift/compare/master...compyle/fork-code-review"
fi
