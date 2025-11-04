# Xwift Emergency Fork Procedures

**Purpose**: Quick-reference guide for emergency network forks to address critical issues
**Audience**: Core developers and emergency response team
**Status**: Living document - update after each fork

---

## When to Initiate Emergency Fork

### Critical Situations Requiring Immediate Fork:
1. **Security Vulnerability Exploitation**
   - Active 51% attack in progress
   - Double-spend attack detected
   - Critical cryptographic vulnerability discovered

2. **Consensus Bugs**
   - Chain split due to implementation bug
   - Invalid blocks being accepted
   - Difficulty algorithm failure

3. **Network Attack**
   - Eclipse attack affecting majority of nodes
   - Time-warp attack manipulating timestamps
   - Sybil attack overwhelming network

4. **Development Fund Issues**
   - Incorrect dev fund allocation
   - Dev fund address compromise
   - Math errors in reward calculation

### Situations NOT Requiring Emergency Fork:
- Individual node issues
- Pool misconfigurations
- Minor performance issues
- Non-critical bugs
- Market price concerns

---

## Pre-Fork Checklist

### Emergency Contact List (Update Before Launch)
- [ ] **Lead Developer**: _[Contact Info]_
- [ ] **Backup Developer**: _[Contact Info]_
- [ ] **Community Manager**: _[Contact Info]_
- [ ] **Major Mining Pools** (top 5 by hashrate)
  - Pool 1: _[Contact]_
  - Pool 2: _[Contact]_
  - Pool 3: _[Contact]_
  - Pool 4: _[Contact]_
  - Pool 5: _[Contact]_
- [ ] **Exchanges** (if listed)
  - Exchange 1: _[Contact]_
  - Exchange 2: _[Contact]_
- [ ] **Block Explorer Operators**
  - Explorer 1: _[Contact]_
- [ ] **Seed Node Operators**
  - Seed 1: _[Contact]_
  - Seed 2: _[Contact]_
  - Seed 3: _[Contact]_

---

## Emergency Fork Process

### Phase 1: Assessment & Decision (30-60 minutes)

**Step 1: Verify the Issue**
```bash
# Check current blockchain state
./xwiftd print_height
./xwiftd print_bc

# Check for consensus issues
./xwiftd diff
./xwiftd alt_chain_info

# Check network status
./xwiftd print_cn
./xwiftd status
```

**Step 2: Determine Severity**
- **Critical**: Immediate fork required (active attack, funds at risk)
- **High**: Fork within 24 hours (serious bug, no immediate fund risk)
- **Medium**: Scheduled fork acceptable (non-critical improvement)

**Step 3: Emergency Team Conference Call**
- Assess technical details
- Determine fork parameters
- Assign responsibilities
- Set timeline

### Phase 2: Code Implementation (1-4 hours)

**Step 1: Create Emergency Branch**
```bash
cd Xwift
git checkout -b emergency-fork-$(date +%Y%m%d)
git push origin emergency-fork-$(date +%Y%m%d)
```

**Step 2: Implement Fix**

Location depends on issue type:
- **Consensus bug**: `src/cryptonote_core/blockchain.cpp`
- **Difficulty attack**: `src/cryptonote_config.h` (DIFFICULTY_WINDOW, etc.)
- **Dev fund issue**: `src/cryptonote_core/cryptonote_tx_utils.cpp`
- **Network attack**: `src/p2p/` directory

**Step 3: Set Fork Activation Height**

Edit `src/cryptonote_config.h`:

```cpp
// Example: Current block is 50000, set activation at 51000 (gives ~8 hours)
#define HF_VERSION_EMERGENCY_FIX   16  // Next available version
#define HF_EMERGENCY_FORK_HEIGHT   51000

// In hard fork table (src/cryptonote_core/blockchain.cpp):
{ 16, HF_EMERGENCY_FORK_HEIGHT, 0, 0 },
```

**Activation Timing Guidelines:**
- **Critical attack**: Current block + 100 blocks (~50 minutes)
- **High severity**: Current block + 500 blocks (~4 hours)
- **Medium severity**: Current block + 2000 blocks (~17 hours)

**Step 4: Update Version Number**

Edit `CMakeLists.txt`:
```cmake
set(VERSION_MAJOR 0)
set(VERSION_MINOR 18)
set(VERSION_PATCH 3)  # Increment patch version
set(VERSION_BUILD 1)  # Increment build number
```

### Phase 3: Testing (1-2 hours)

**Critical: Do NOT skip testing even in emergency**

**Step 1: Build Emergency Binary**
```bash
make clean
make release -j$(nproc)

# Verify version
./build/release/bin/xwiftd --version
```

**Step 2: Test on Private Testnet**
```bash
# Start test daemon
./xwiftd --testnet --fixed-difficulty 1 --start-mining TEST_ADDRESS

# Mine to just before fork height
# Verify fork activates correctly
# Test the fix works as expected
```

**Step 3: Verify Binary Integrity**
```bash
# Create checksums
sha256sum build/release/bin/xwiftd > SHA256SUMS
sha256sum build/release/bin/xwift-wallet-cli >> SHA256SUMS
sha256sum build/release/bin/xwift-wallet-rpc >> SHA256SUMS
```

### Phase 4: Communication (Parallel with Phase 3)

**Step 1: Draft Emergency Announcement**

Template:
```markdown
🚨 EMERGENCY FORK ANNOUNCEMENT 🚨

**Issue**: [Brief description of vulnerability without revealing exploit details]
**Severity**: CRITICAL / HIGH / MEDIUM
**Action Required**: Update to v0.18.x.x immediately
**Fork Height**: Block [HEIGHT] (estimated time: [TIMESTAMP])
**Download**: https://github.com/xwift/xwift/releases/tag/v0.18.x.x

## Who Must Update:
- All node operators
- Mining pools
- Exchanges
- Wallet users (if affected)

## Timeline:
- Now: Binaries released
- [TIME]: Fork activation at block [HEIGHT]
- [TIME + 1hr]: Network monitoring

## Instructions:
1. Stop your xwiftd daemon
2. Download new binary from official source
3. Verify SHA256: [HASH]
4. Replace old binary
5. Restart daemon
6. Verify version: ./xwiftd --version

## Support:
- Discord: [LINK]
- Telegram: [LINK]
- Email: emergency@xwift.io

**DO NOT update from unofficial sources**
```

**Step 2: Alert Stakeholders**

**Priority 1: Mining Pools (within 15 minutes)**
- Direct message/call each pool operator
- Provide binary and clear instructions
- Confirm receipt and update timeline

**Priority 2: Exchanges (within 30 minutes)**
- Email + direct contact
- Request trading halt if necessary
- Provide update instructions

**Priority 3: Community (within 1 hour)**
- Post to Discord/Telegram
- Tweet from official account
- Update website banner
- Pin announcements

### Phase 5: Binary Distribution (30 minutes)

**Step 1: Create GitHub Release**
```bash
# Tag the release
git tag -a v0.18.x.x -m "Emergency fork: [description]"
git push origin v0.18.x.x

# Upload binaries to GitHub Releases
# Include SHA256SUMS file
```

**Step 2: Update Official Channels**
- Website download page
- Documentation
- Quick start guides

**Step 3: Deploy to Seed Nodes**
```bash
# For each seed node
ssh seed1.xwift.network
cd /opt/xwift
sudo systemctl stop xwiftd
sudo cp /path/to/new/xwiftd /usr/local/bin/
sudo systemctl start xwiftd
sudo systemctl status xwiftd
```

### Phase 6: Monitoring & Support (Until fork complete + 24 hours)

**Step 1: Monitor Fork Activation**
```bash
# Watch block height approaching fork
watch -n 10 './xwiftd print_height'

# At fork height, verify new rules active
./xwiftd print_block [FORK_HEIGHT]
./xwiftd hard_fork_info
```

**Step 2: Monitor Network Health**
```bash
# Check peer versions
./xwiftd print_cn

# Monitor for chain splits
./xwiftd alt_chain_info

# Check hashrate stability
curl http://localhost:19081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json'
```

**Step 3: Community Support**
- Monitor Discord/Telegram for issues
- Respond to update questions
- Track pool/exchange update status
- Document any unexpected issues

**Step 4: Post-Fork Validation (24 hours after)**
- Verify network stable
- Confirm no chain splits
- Check that fix resolved issue
- Monitor for any side effects

---

## Post-Fork Analysis

### Required Documentation

**Within 48 hours, create POST_MORTEM.md:**

```markdown
# Emergency Fork Post-Mortem

## Incident Details
- Date/Time:
- Block Height:
- Issue Description:
- Severity:

## Timeline
- [TIME]: Issue discovered
- [TIME]: Emergency team convened
- [TIME]: Fix implemented
- [TIME]: Binaries released
- [TIME]: Fork activated
- [TIME]: Issue resolved

## What Went Well
-

## What Went Wrong
-

## Action Items
- [ ]
- [ ]

## Lessons Learned
-
```

### Update Procedures
- Review this document
- Update contact list
- Improve automation
- Add preventive measures

---

## Technical Reference

### Blockchain State Commands
```bash
# Current height
./xwiftd print_height

# Block information
./xwiftd print_block <HEIGHT>

# Hard fork info
./xwiftd hard_fork_info

# Peer information
./xwiftd print_cn

# Alternative chains
./xwiftd alt_chain_info

# Difficulty info
./xwiftd print_bc <HEIGHT>

# Network status
./xwiftd status
```

### Key Configuration Files
- `src/cryptonote_config.h` - Network parameters, consensus rules
- `src/cryptonote_core/blockchain.cpp` - Hard fork table, validation
- `src/cryptonote_core/cryptonote_tx_utils.cpp` - Transaction creation, dev fund
- `CMakeLists.txt` - Version numbers

### Common Emergency Fixes

**1. Difficulty Adjustment Fix**
```cpp
// src/cryptonote_config.h
#define DIFFICULTY_WINDOW  16  // Widen window
#define DIFFICULTY_LAG     2   // Increase lag
```

**2. Block Time Adjustment**
```cpp
// src/cryptonote_config.h
#define DIFFICULTY_TARGET_V2  45  // Change from 30
```

**3. Disable Development Fund (Emergency)**
```cpp
// src/cryptonote_core/cryptonote_tx_utils.cpp
if (height <= config::DEV_FUND_DURATION_BLOCKS && height != height) {  // Never true
  // Dev fund disabled
}
```

**4. Add Checkpoint (Stop Reorg)**
```cpp
// src/checkpoints/checkpoints.cpp
ADD_CHECKPOINT(50000, "actual_block_hash_at_50000");
```

---

## Emergency Scenarios & Responses

### Scenario 1: 51% Attack in Progress

**Indicators:**
- Large chain reorg detected (>10 blocks)
- Double-spend transactions confirmed
- Single entity controlling majority hashrate

**Response:**
1. Immediately halt trading on exchanges
2. Implement checkpoint at last known-good block
3. Deploy fix within 2 hours
4. Set fork height 100 blocks after current (urgent)

### Scenario 2: Development Fund Address Compromised

**Indicators:**
- Unauthorized transactions from dev fund address
- Private keys suspected stolen

**Response:**
1. Generate new secure dev fund address (cold wallet/multisig)
2. Update `DEV_FUND_ADDRESS` in config
3. Deploy fix within 12 hours
4. Set fork height to retroactively redirect dev fund

### Scenario 3: Consensus Bug Causing Chain Split

**Indicators:**
- Multiple valid chains exist
- Nodes showing different top blocks
- Hashrate split between chains

**Response:**
1. Identify which chain is "correct"
2. Fix validation bug
3. Add checkpoint on correct chain
4. Deploy within 4 hours
5. Guide majority of hashrate to correct chain

### Scenario 4: Time-Warp Attack

**Indicators:**
- Block timestamps jumping wildly
- Difficulty dropping artificially
- Rapid block generation

**Response:**
1. Implement stricter timestamp validation
2. Widen difficulty window
3. Deploy within 6 hours
4. Add timestamp median check

---

## Emergency Testing Checklist

Before deploying any emergency fork:

- [ ] Issue is correctly identified and understood
- [ ] Fix has been implemented and code-reviewed
- [ ] Fork height set with adequate warning time
- [ ] Binary compiles successfully on all platforms
- [ ] Fix tested on private testnet
- [ ] Version number updated
- [ ] SHA256 checksums generated
- [ ] All stakeholders notified
- [ ] Announcement drafted and ready
- [ ] Seed nodes updated
- [ ] Monitoring plan in place
- [ ] Rollback plan prepared (if applicable)

---

## Support & Resources

### Emergency Contacts
- **Security Issues**: security@xwift.io
- **Technical Support**: dev@xwift.io
- **Emergency Hotline**: _[Phone Number]_

### Official Channels
- **GitHub**: https://github.com/xwift/xwift
- **Discord**: _[Link]_
- **Telegram**: _[Link]_
- **Twitter**: @xwift_official

### Documentation
- Main README: `/Xwift/README.md`
- Technical Specs: `/Xwift/XWIFT_SPECIFICATION.md`
- Deployment Guide: `/Xwift/DEPLOYMENT_GUIDE.md`

---

**Document Version**: 1.0
**Last Updated**: 2025-11-04
**Next Review**: Before mainnet launch

**Remember**: Communication is as important as the technical fix. Keep stakeholders informed throughout the process.
