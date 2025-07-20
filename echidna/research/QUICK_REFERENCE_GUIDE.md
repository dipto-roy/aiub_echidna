# Quick Reference Guide - Novel Vulnerability Discovery Framework

## 🚀 Quick Start

### Prerequisites
- Echidna 2.2.6 installed
- Python 3.8+
- Solidity compiler 0.8.0+

### Basic Usage
```bash
# 1. Run fuzzing campaign
cd /path/to/research
echidna . --contract EconomicLogicLab --config discovery_config.yaml

# 2. Analyze results
python3 vulnerability_discovery.py ./corpus

# 3. Enhanced analysis
python3 enhanced_vulnerability_discovery.py ./corpus
```

## 📋 File Reference

| File | Purpose | Key Features |
|------|---------|--------------|
| `vulnerability_discovery.sol` | Smart contract lab | 5 vulnerability-focused contracts |
| `vulnerability_discovery.py` | Basic analyzer | Pattern detection, severity assessment |
| `enhanced_vulnerability_discovery.py` | Advanced analyzer | Complexity scoring, attack scenarios |
| `discovery_config.yaml` | Deep fuzzing config | 1M tests, long sequences, time delays |
| `simple_config.yaml` | Quick testing config | 50K tests, faster iteration |

## 🎯 Contract Labs

| Lab | Target Vulnerabilities | Key Functions |
|-----|----------------------|---------------|
| StateCorruptionLab | State inconsistencies | `complexTransfer()` |
| TemporalLogicLab | Time-based attacks | `scheduleAction()`, `executeAction()` |
| CrossFunctionalLab | Mode interactions | `stake()`, `switchMode()` |
| EconomicLogicLab | DeFi manipulations | `addLiquidity()`, `swap()` |
| MetadataLab | Identity confusion | `createToken()`, `updateMetadata()` |

## 🔍 Key Echidna Properties

### State Corruption Detection
- `echidna_total_balance_conservation()`
- `echidna_allowance_consistency()`
- `echidna_locked_amount_bounds()`

### Temporal Logic Validation
- `echidna_time_consistency()`
- `echidna_execution_window()`

### Cross-Functional Integrity
- `echidna_stake_consistency()`
- `echidna_reward_conservation()`

### Economic Invariants
- `echidna_constant_product()`
- `echidna_price_bounds()`
- `echidna_no_arbitrary_minting()`

### Metadata Consistency
- `echidna_metadata_consistency()`
- `echidna_controller_privileges()`

## 📊 Output Interpretation

### Vulnerability Severity Levels
- **CRITICAL**: Fund loss, state corruption, protocol breaking
- **HIGH**: Significant impact, complex exploitation
- **MEDIUM**: Moderate impact, exploitable under conditions
- **LOW**: Minor impact, edge case vulnerabilities

### Key Metrics
- **Novelty Score**: 0.0-1.0 (higher = more novel)
- **Complexity Score**: 0.0-1.0 (higher = more complex)
- **Frequency**: Number of reproducers found

### Pattern Types
- `complex_transfer_manipulation`: Multi-parameter transfer exploits
- `defi_liquidity_manipulation`: AMM/DEX attacks
- `temporal_logic_exploit`: Time-dependent vulnerabilities
- `hybrid_defi_transfer_manipulation`: Combined attack vectors

## 🛠️ Configuration Options

### Deep Discovery (`discovery_config.yaml`)
```yaml
testLimit: 1000000    # Extended testing
seqLen: 100          # Long attack sequences
maxTimeDelay: 604800 # 1 week time manipulation
workers: 8           # Parallel processing
```

### Quick Testing (`simple_config.yaml`)
```yaml
testLimit: 50000     # Faster iteration
seqLen: 50          # Shorter sequences  
timeout: 1800       # 30-minute limit
workers: 4          # Moderate parallelization
```

## 📁 Output Structure

```
corpus/
├── reproducers/           # Minimized attack vectors
├── reproducers-unshrunk/ # Full attack sequences
├── coverage/             # Code coverage data
├── cache/               # Fuzzing cache
└── *.md                # Analysis reports
```

## 🎯 Key Discovery: Hybrid DeFi Transfer Manipulation

### Attack Vector
Complex token transfer manipulation + DeFi liquidity pool exploitation + Temporal logic bypass

### Technical Signature
- Functions: `complexTransfer`, `addLiquidity`, `swap`
- Time delays: Up to 586,022 time units
- Multi-address interactions
- Extreme value manipulation

### Mitigation Strategies
1. Implement reentrancy guards on all transfer functions
2. Add state consistency checks after transfers
3. Implement slippage protection mechanisms
4. Add liquidity manipulation detection
5. Remove time-dependent logic from critical functions
6. Add comprehensive state invariant checks

## 🔄 Workflow

### Research Workflow
1. **Design**: Create vulnerability-focused contracts
2. **Fuzz**: Run extended Echidna campaigns
3. **Analyze**: Extract patterns from reproducers
4. **Classify**: Assess novelty and severity
5. **Report**: Generate comprehensive findings
6. **Validate**: Confirm with manual analysis

### Development Workflow
1. **Test**: Run quick fuzzing on new contracts
2. **Analyze**: Check for known patterns
3. **Enhance**: Add targeted properties
4. **Validate**: Extended fuzzing campaigns
5. **Document**: Record findings and mitigations

## ⚡ Performance Tips

### Faster Analysis
- Use `simple_config.yaml` for initial testing
- Focus on specific contracts with `--contract`
- Use parallel workers for large campaigns

### Deeper Discovery
- Increase `testLimit` for complex patterns
- Extend `seqLen` for multi-step attacks
- Enable time delays for temporal vulnerabilities

### Resource Management
- Monitor gas limits for complex operations
- Use coverage data to guide property enhancement
- Analyze reproducer patterns to optimize configurations

## 🚨 Common Issues

### No Patterns Found
- Increase test limit
- Check property definitions
- Verify contract functionality
- Review configuration settings

### Parse Errors
- Ensure JSON format in reproducers
- Check file permissions
- Verify Python dependencies

### False Positives
- Review property logic
- Check for intentional failures
- Validate with manual analysis

## 📚 Further Reading

- `methodology.md`: Complete research methodology
- `novel_vulnerability_discovery_summary.md`: Key findings
- `COMPREHENSIVE_CODEBASE_DOCUMENTATION.md`: Full technical documentation

---

*Quick Reference for Novel Vulnerability Discovery Framework v1.0*
