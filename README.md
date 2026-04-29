# Access Control Update (Ownable -> MultiSig)

While reviewing the contracts, I noticed that all privileged operations were controlled using the standard Ownable / Claimable pattern. This means a single address had full control over critical functions like fund transfers, upgrade mechanisms, and recovery operations.

This setup creates a clear single point of failure. If that one private key is compromised, lost, or misused, the entire system can be affected -- including loss of funds or unintended upgrades.

To address this, I replaced the single-owner model with a simple multi-signature ownership system (M-of-N).

Instead of allowing one account to execute admin actions directly, the flow now requires:

- submitting a transaction
- getting approvals from multiple owners
- executing the transaction once the required threshold is met

This ensures that no single actor can take unilateral control of sensitive operations.

---

## Why this approach

I kept the implementation straightforward and on-chain (submit -> approve -> execute), mainly to stay compatible with Solidity 0.4.x and avoid adding unnecessary complexity like off-chain signatures.

The goal here was to remove the single point of failure while keeping the system understandable and lightweight.

---

## Improvements

- Removes reliance on a single private key
- Requires multiple approvals for critical actions
- Reduces risk of accidental or malicious execution
- Makes admin activity more explicit and traceable

## Tradeoffs

- No timelock mechanism (transactions execute immediately after enough approvals)
- Uses low-level call for flexibility
- Not as feature-rich as production-grade solutions like Gnosis Safe

## Next Steps (if extended further)

- Add timelock for high-impact actions
- Support off-chain approvals (EIP-712)
- Integrate with a standard multisig wallet like Gnosis Safe
