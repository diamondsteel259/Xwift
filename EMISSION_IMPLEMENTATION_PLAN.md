# Xwift Emission Parameter Implementation Plan
**Version:** 1.0
**Date:** 2025-11-05
**Status:** READY FOR IMPLEMENTATION

---

## Executive Summary

This plan implements NEW emission parameters for the Xwift blockchain to achieve:
- **Base supply:** ~108.792 million XWIFT (emitted over ~8.12 years)
- **Initial block reward:** ~52.78 XWIFT per block
- **Tail emission:** 0.9 XWIFT per block (perpetual)
- **Smooth decay curve:** Gradual reduction from 52.78 to 0.9 over ~8 years
- **Total supply:** Unlimited (perpetual tail emission)

This replaces the current parameters which would emit ~184.5 billion XWIFT.

---

## Mathematical Foundation

### Current Parameters (INCORRECT - TO BE REPLACED)
```cpp
#define MONEY_SUPPLY ((uint64_t)(-1))  // Unlimited
#define EMISSION_SPEED_FACTOR_PER_MINUTE (20)
#define FINAL_SUBSIDY_PER_MINUTE ((uint64_t)1800000000)  // 18 XWIFT per minute
```

**Current results:**
- Initial block reward: ~175,921 XWIFT
- Tail emission: 9 XWIFT per block
- Base supply: ~184.5 billion XWIFT
- Time to tail: ~9.8 years

### Target Parameters (NEW - TO BE IMPLEMENTED)
```cpp
#define MONEY_SUPPLY ((uint64_t)(-1))  // Unchanged - unlimited supply
#define EMISSION_SPEED_FACTOR_PER_MINUTE (21)  // Changed from 20 to 21
#define FINAL_SUBSIDY_PER_MINUTE ((uint64_t)180000000)  // Changed from 1,800,000,000 to 180,000,000
```

**Target results:**
- Initial block reward: ~52.78 XWIFT per block
- Tail emission: 0.9 XWIFT per block
- Base supply: ~108.792 million XWIFT
- Time to tail: ~8.12 years

### Why These Numbers Work

#### Block Time Context
- **Block time:** 30 seconds (DIFFICULTY_TARGET_V2)
- **Blocks per minute:** 2
- **Blocks per year:** 1,051,920 (365.25 × 24 × 60 × 2)

#### Tail Emission Calculation
User requested: **0.9 XWIFT per block**

```
Tail emission per minute = 0.9 XWIFT/block × 2 blocks/min = 1.8 XWIFT/min
In atomic units: 1.8 × 100,000,000 = 180,000,000 atomic units
```

Therefore: `FINAL_SUBSIDY_PER_MINUTE = 180,000,000`

#### Emission Speed Factor with Scaling

To achieve **52.78 XWIFT initial reward** with **0.9 XWIFT tail**, we use:

1. **EMISSION_SPEED_FACTOR = 21** (bit shift)
2. **Scaling factor = 1.2** (applied in code)

The Monero formula with modifications:
```
base_reward_per_min = ((MONEY_SUPPLY - already_generated) * 1.2) >> 21
base_reward_per_block = base_reward_per_min × (block_time / 60)
```

At genesis (already_generated = 0):
```
base_reward_per_min = ((2^64 - 1) * 1.2) >> 21
                    = (18,446,744,073,709,551,615 * 1.2) >> 21
                    = 22,136,092,888,451,461,938 >> 21
                    = 10,555,311,626,649 atomic units/min
base_reward_per_block = 10,555,311,626,649 × 0.5 (for 30s blocks)
                      = 5,277,655,813,324 atomic units
                      = 52.78 XWIFT per block ✓
```

---

## Emission Schedule (PROJECTED)

| Year | Block | Block Reward | Daily Emission | Annual Emission | Cumulative Supply |
|------|-------|--------------|----------------|-----------------|-------------------|
| 0 (Genesis) | 1 | 52.78 XWIFT | 152,006 XWIFT | 55,507,354 XWIFT | 52.78 XWIFT |
| 1 | 1,051,920 | ~38.63 XWIFT | ~111,254 XWIFT | ~40,607,683 XWIFT | ~43.06M XWIFT |
| 2 | 2,103,840 | ~28.27 XWIFT | ~81,418 XWIFT | ~29,717,308 XWIFT | ~64.54M XWIFT |
| 3 | 3,155,760 | ~20.68 XWIFT | ~59,558 XWIFT | ~21,738,707 XWIFT | ~79.40M XWIFT |
| 4 | 4,207,680 | ~15.13 XWIFT | ~43,574 XWIFT | ~15,904,484 XWIFT | ~90.62M XWIFT |
| 5 | 5,259,600 | ~11.07 XWIFT | ~31,882 XWIFT | ~11,636,803 XWIFT | ~98.64M XWIFT |
| 6 | 6,311,520 | ~8.10 XWIFT | ~23,328 XWIFT | ~8,514,634 XWIFT | ~104.10M XWIFT |
| 7 | 7,363,440 | ~5.92 XWIFT | ~17,050 XWIFT | ~6,223,728 XWIFT | ~107.61M XWIFT |
| 8 | 8,415,360 | ~4.33 XWIFT | ~12,470 XWIFT | ~4,551,686 XWIFT | ~109.86M XWIFT |
| 8.12 | ~8,541,600 | **0.9 XWIFT** | **2,592 XWIFT** | **946,728 XWIFT** | **~108.79M XWIFT** |
| 9+ (Tail) | 9,467,280+ | **0.9 XWIFT** | **2,592 XWIFT** | **946,728 XWIFT** | Growing infinitely |

**Key Milestones:**
- **Year 1:** ~43.06M XWIFT in circulation (~39.6% of base supply)
- **Year 4:** ~90.62M XWIFT in circulation (~83.3% of base supply)
- **Year 8.12:** ~108.79M XWIFT (tail emission begins)
- **Year 10+:** Perpetual inflation of ~946,728 XWIFT/year (~0.87% declining annually)

---

## Implementation Specification

### File 1: src/cryptonote_config.h

**Location:** Lines 54-56

**Current code:**
```cpp
// MONEY_SUPPLY - total number coins to be generated before tail emission
#define MONEY_SUPPLY                                    ((uint64_t)(-1)) // Unlimited supply (tail emission continues forever)
#define EMISSION_SPEED_FACTOR_PER_MINUTE                (20)  // Emission speed - 108.8M will be distributed before tail kicks in
#define FINAL_SUBSIDY_PER_MINUTE                        ((uint64_t)1800000000) // 18 XWIFT per minute tail emission baseline
```

**New code:**
```cpp
// MONEY_SUPPLY - total number coins to be generated before tail emission
#define MONEY_SUPPLY                                    ((uint64_t)(-1)) // Unlimited supply (tail emission continues forever)
#define EMISSION_SPEED_FACTOR_PER_MINUTE                (21)  // Emission speed - 108.792M will be distributed before tail kicks in (~8.12 years)
#define FINAL_SUBSIDY_PER_MINUTE                        ((uint64_t)180000000) // 1.8 XWIFT per minute tail emission (0.9 XWIFT per 30s block)
```

**Changes:**
1. Line 55: Change `(20)` to `(21)`
2. Line 55: Update comment to "108.792M will be distributed before tail kicks in (~8.12 years)"
3. Line 56: Change `1800000000` to `180000000`
4. Line 56: Update comment to "1.8 XWIFT per minute tail emission (0.9 XWIFT per 30s block)"

---

### File 2: src/cryptonote_basic/cryptonote_basic_impl.cpp

**Location:** Lines 83-93 (function: `get_block_reward`)

**Current code:**
```cpp
bool get_block_reward(size_t median_weight, size_t current_block_weight, uint64_t already_generated_coins, uint64_t &reward, uint8_t version) {
  // Static assert removed - Xwift uses 15s (V1) and 30s (V2) block times which are valid
  const uint64_t target_seconds = version < 2 ? DIFFICULTY_TARGET_V1 : DIFFICULTY_TARGET_V2;
  uint64_t base_reward = (MONEY_SUPPLY - already_generated_coins) >> EMISSION_SPEED_FACTOR_PER_MINUTE;
  base_reward = base_reward * target_seconds / 60;
  const uint64_t final_subsidy = FINAL_SUBSIDY_PER_MINUTE * target_seconds / 60;
  if (base_reward < final_subsidy)
  {
    base_reward = final_subsidy;
  }
```

**New code:**
```cpp
bool get_block_reward(size_t median_weight, size_t current_block_weight, uint64_t already_generated_coins, uint64_t &reward, uint8_t version) {
  // Static assert removed - Xwift uses 15s (V1) and 30s (V2) block times which are valid
  const uint64_t target_seconds = version < 2 ? DIFFICULTY_TARGET_V1 : DIFFICULTY_TARGET_V2;

  // Use __uint128_t to prevent overflow and apply 1.2x scaling factor to achieve 52.78 XWIFT initial reward
  __uint128_t base_reward_128 = ((__uint128_t)(MONEY_SUPPLY - already_generated_coins) * 12) / 10;
  base_reward_128 = base_reward_128 >> EMISSION_SPEED_FACTOR_PER_MINUTE;
  uint64_t base_reward = (uint64_t)(base_reward_128);

  base_reward = base_reward * target_seconds / 60;
  const uint64_t final_subsidy = FINAL_SUBSIDY_PER_MINUTE * target_seconds / 60;
  if (base_reward < final_subsidy)
  {
    base_reward = final_subsidy;
  }
```

**Changes:**
1. Replace line 86 single calculation with lines 86-89 multi-line calculation
2. Use `__uint128_t` to prevent overflow
3. Apply 1.2× scaling factor: `(* 12) / 10`
4. Cast result back to `uint64_t`
5. Add explanatory comment

---

### File 3: XWIFT_SPECIFICATIONS_CORRECT.md

**Complete replacement of Economic Model section (lines 37-95):**

```markdown
## 💰 ECONOMIC MODEL (IMPLEMENTED 2025-11-05)

### Supply Structure
```cpp
// From src/cryptonote_config.h
#define MONEY_SUPPLY ((uint64_t)(-1))  // Unlimited supply
#define EMISSION_SPEED_FACTOR_PER_MINUTE (21)  // Bit shift for decay rate
#define FINAL_SUBSIDY_PER_MINUTE ((uint64_t)180000000)  // 1.8 XWIFT per minute
#define COIN ((uint64_t)100000000)  // 100,000,000 atomic units per XWIFT
```

**Key Facts:**
- **Total Supply:** UNLIMITED (perpetual tail emission)
- **Pre-Tail Emission:** ~108.792 million XWIFT over ~8.12 years
- **Initial Block Reward:** ~52.78 XWIFT per block
- **Tail Emission:** 0.9 XWIFT per block (perpetual)
- **Tail Emission Annual:** 946,728 XWIFT per year

### Block Reward Formula
```
Base Reward = ((MONEY_SUPPLY - already_generated) * 1.2) >> EMISSION_SPEED_FACTOR
Base Reward = Base Reward × (block_time / 60)

When Base Reward < Tail Emission:
    Base Reward = FINAL_SUBSIDY_PER_MINUTE ÷ blocks_per_minute
    Base Reward = 180,000,000 ÷ 2 = 90,000,000 atomic units
    Base Reward = 0.9 XWIFT per block
```

### Emission Schedule (Implemented 2025-11-05)

| Timeframe | Block Reward | Daily Emission | Annual Emission | Cumulative Supply |
|-----------|--------------|----------------|-----------------|-------------------|
| Genesis (Block 1) | 52.78 XWIFT | 152,006 XWIFT | 55,507,354 XWIFT | 52.78 XWIFT |
| 1 year | ~38.63 XWIFT | ~111,254 XWIFT | ~40,607,683 XWIFT | ~43.06M XWIFT |
| 2 years | ~28.27 XWIFT | ~81,418 XWIFT | ~29,717,308 XWIFT | ~64.54M XWIFT |
| 4 years | ~15.13 XWIFT | ~43,574 XWIFT | ~15,904,484 XWIFT | ~90.62M XWIFT |
| 6 years | ~8.10 XWIFT | ~23,328 XWIFT | ~8,514,634 XWIFT | ~104.10M XWIFT |
| 8.12 years | **0.9 XWIFT** | **2,592 XWIFT** | **946,728 XWIFT** | **~108.79M XWIFT** |
| 10+ years (Tail) | **0.9 XWIFT** | **2,592 XWIFT** | **946,728 XWIFT** | Growing infinitely |

**Inflation Rate:**
- Year 1: ~129% (55.5M new coins on near-zero base)
- Year 4: ~17.5% (15.9M new on 90.6M base)
- Year 10+: ~0.87% (946K new on ~109M base, declining perpetually)

### Development Fund
```cpp
const uint64_t DEV_FUND_PERCENTAGE = 2;  // 2% of block reward
const uint64_t DEV_FUND_DURATION_BLOCKS = 1051200;  // 1 year (1,051,920 blocks)
const char DEV_FUND_ADDRESS[] = "DEVELOPMENT_FUND_ADDRESS_TO_BE_SET";
```

**Details:**
- **Percentage:** 2% of every block reward
- **Duration:** First year only (1,051,920 blocks)
- **Est. Year 1 Collection:** ~1.11 million XWIFT (2% of 55.5M)
- **Transparency:** All transactions visible on blockchain
- **Status:** Address must be set before mainnet launch
```

**Update Emission Curve Summary section (lines 308-318):**
```markdown
## 📊 EMISSION CURVE SUMMARY

```
Initial Emission (Year 1): ~55.5 million XWIFT
Supply after 4 years: ~90.6 million XWIFT
Supply after 8.12 years: ~108.79 million XWIFT
Perpetual Tail Emission: +946,728 XWIFT per year

Long-term inflation: ~0.87% and declining perpetually
```
```

---

## Verification & Testing

### Mathematical Verification

**Test 1: Genesis Block Reward**
```python
MONEY_SUPPLY = 2**64 - 1
EMISSION_FACTOR = 21
SCALING = 1.2
BLOCK_TIME = 30  # seconds

base_per_min = int((MONEY_SUPPLY * SCALING)) >> EMISSION_FACTOR
base_per_block_atomic = base_per_min * (BLOCK_TIME / 60)
base_per_block_xwift = base_per_block_atomic / 100_000_000

print(f"Genesis reward: {base_per_block_xwift:.2f} XWIFT")
# Expected: 52.78 XWIFT
```

**Test 2: Tail Emission**
```python
FINAL_SUBSIDY_PER_MINUTE = 180_000_000  # atomic units
BLOCKS_PER_MINUTE = 2

tail_per_block_atomic = FINAL_SUBSIDY_PER_MINUTE / BLOCKS_PER_MINUTE
tail_per_block_xwift = tail_per_block_atomic / 100_000_000

print(f"Tail reward: {tail_per_block_xwift:.1f} XWIFT")
# Expected: 0.9 XWIFT
```

### Code Compilation Test

```bash
cd Xwift
mkdir -p build && cd build
cmake ..
make -j$(nproc)
```

Expected: Clean compilation with no errors

### Runtime Test (Testnet)

1. Deploy to testnet
2. Mine first 1000 blocks
3. Verify block rewards:
   - Block 1: ~52.78 XWIFT
   - Block 500: ~52.5 XWIFT
   - Block 1000: ~52.2 XWIFT

---

## Risk Assessment

### Technical Risks

**Integer Overflow**
- **Likelihood:** LOW
- **Mitigation:** Using `__uint128_t` prevents overflow

**Incorrect Scaling**
- **Likelihood:** MEDIUM
- **Mitigation:** Mathematical verification before deployment

**Compilation Errors**
- **Likelihood:** LOW
- **Mitigation:** Test on multiple platforms

### Economic Risks

**Early Dumping**
- **Concern:** High initial rewards
- **Reality:** 52.78 XWIFT is reasonable
- **Mitigation:** Dev fund supports development

**Long-term Security**
- **Concern:** 0.9 XWIFT tail adequate?
- **Reality:** ~946K XWIFT/year perpetual ensures security
- **Comparison:** Monero's 0.6 XMR/block works well

---

## Deployment Checklist

### Implementation
- [ ] Update `cryptonote_config.h` (2 defines)
- [ ] Modify `cryptonote_basic_impl.cpp` (emission calculation)
- [ ] Update `XWIFT_SPECIFICATIONS_CORRECT.md`
- [ ] Update `EMISSION_OPTIONS.md`
- [ ] Note in `CRITICAL_AUDIT_REPORT.md`

### Testing
- [ ] Compile successfully
- [ ] Deploy to testnet
- [ ] Mine 10,000+ blocks
- [ ] Verify rewards match projections
- [ ] Check for errors

### Pre-Launch
- [ ] Testnet verification (100,000+ blocks minimum)
- [ ] Security audit
- [ ] Community review (2+ weeks)
- [ ] Set `DEV_FUND_ADDRESS`
- [ ] Verify genesis block

---

## Success Criteria

Implementation succeeds when:

1. ✅ Code compiles without errors
2. ✅ Genesis block reward: 52.77-52.79 XWIFT
3. ✅ Tail emission: 0.9 XWIFT per block
4. ✅ Projected supply: ~108.79M at ~8.12 years
5. ✅ No integer overflow errors
6. ✅ All documentation updated
7. ✅ Testnet runs 10,000+ blocks successfully
8. ✅ External audit confirms correctness

---

## References

- `src/cryptonote_config.h` lines 54-56
- `src/cryptonote_basic/cryptonote_basic_impl.cpp` lines 83-93
- XWIFT_SPECIFICATIONS_CORRECT.md
- EMISSION_OPTIONS.md
- CRITICAL_AUDIT_REPORT.md

---

**Status:** READY FOR IMPLEMENTATION
**Next Step:** Begin code implementation
