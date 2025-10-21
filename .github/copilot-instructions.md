# Guidance for AI coding agents

This repository contains Foundry-based solutions to Ethernaut puzzles. The goal of this file is to give an AI coding agent the minimal, actionable context needed to work productively: how the project is structured, the developer workflows, important conventions, and concrete examples to follow.

- Language & tools: Solidity (>=0.8.x), Foundry (forge). Tests use `forge-std` (`Test.sol`, `console2.sol`, `stdStorage`, `stdCheats`).
- Project purpose: each level is solved via a Foundry test that performs the exploit end-to-end (TDD-style). Tests are the primary entry points and executables.

Key files and directories
- `foundry.toml` — project config (src/out/libs). Also lists an RPC endpoint alias `sepolia` used for forking in tests.
- `README.md` — setup notes: install Foundry, `forge install`, set `SEPOLIA_RPC_URL` in `.env` for forked tests.
- `src/` — challenge contracts and helper contracts (e.g. `Counter.sol`).
- `test/` — Foundry tests that implement and validate exploits. Look for `setUp()` and `test_*` functions (examples: `test/Fallback.t.sol`, `test/Counter.t.sol`).
- `lib/forge-std/` — vendored forge-std helpers and docs; tests import `forge-std/Test.sol` from here.
- `.github/workflows/test.yml` — CI commands: `forge fmt --check`, `forge build --sizes`, `forge test -vvv` (uses `SEPOLIA_RPC_URL` secret).

Important patterns and conventions (concrete and discoverable)
- Tests as exploits: each `test/*.t.sol` file constructs the scenario in `setUp()` and performs the exploit in a `test_*` function. Success is asserted with `assertEq` or other std assertions.
- Forking & environment: tests that target live-chain state call `vm.createSelectFork("sepolia")` in `setUp()`; ensure `SEPOLIA_RPC_URL` is provided in env or CI secret.
- Use of cheatcodes: tests rely on `vm` (from `forge-std/Test.sol`) for forks, pranks, deals, and `stdstore` helpers for direct storage writes/reads. Examples:
  - `vm.createSelectFork("sepolia")` — select and fork the Sepolia endpoint.
  - `hoax`, `prank`, `deal`, `vm.expectRevert`, and `stdstore.target(...).sig(...).find()` (see `lib/forge-std/README.md`).
- Console logging: prefer `console2.log(...)` (imported via `Test.sol`) to get decoded logs in Forge traces.
- Test selection for iteration: use `forge test --match-path test/<File>.t.sol -vv` for focused runs.

Developer workflows (commands you can run)
- Install dependencies: `forge install` (uses `lib/` entries and `lib/forge-std` is already present).
- Run full test suite: `forge test -vvv` (CI uses this) — ensure `SEPOLIA_RPC_URL` is exported if tests fork.
- Run a single test file: `forge test --match-path test/Fallback.t.sol -vv`.
- Formatting and build checks: `forge fmt --check`, `forge build --sizes`.

Common pitfalls and how to handle them
- Missing RPC env: tests that call `vm.createSelectFork("sepolia")` will fail without `SEPOLIA_RPC_URL`. Provide via `.env` locally or GitHub secret `SEPOLIA_RPC_URL` in CI.
- Console vs console2: prefer `console2.sol` (via `Test.sol`) for decoded traces; `console.sol` may mis-decode int/uint in traces.
- Foundry caching: the repo includes `cache/` and `foundry.lock`; run `forge update` only if you change libs.

Examples (copyable snippets found in repo)
- Forking in `setUp()`:

  vm.createSelectFork("sepolia");

- Simple test structure (from `test/Counter.t.sol`):

  contract CounterTest is Test {
      function setUp() public { counter = new Counter(); }
      function test_Increment() public { counter.increment(); assertEq(counter.number(), 1); }
  }

Where to look first
- Start with `test/` files for the level you need to modify — they contain the scenario, target address (for on-chain levels), and the exploit flow.
- Inspect `src/` for contract source to identify state/layout/visibility that tests exploit.
- Consult `lib/forge-std/README.md` for idiomatic cheatcode usage patterns used across tests.

If you change tests or add new exploit scripts
- Keep tests deterministic and idempotent. Use `vm.createSelectFork` for on-chain state, and `deal`/`hoax` when you need balances or `prank` when impersonating.
- Add clear assertions for success conditions (use `assertEq`, `assertTrue`, or `console2.log` for diagnostic traces).

Notes for AI agents
- Do not change CI workflow unless necessary. Follow the existing test-first pattern: implement code in `src/` only when a test requires it, then run the test.
- Prefer small, verifiable edits — modify or add a test that demonstrates the exploit and assert the invariant explicitly.
- When you need to inspect state, run focused tests locally with `--match-path` and `-vv` to get traces.

Questions or missing info
- If any tests rely on private envs or keys not present in this workspace, ask the maintainer for the secret (e.g., a Sepolia RPC key) before attempting to run forked tests.

---
Please review this guidance. Tell me if you want more examples (e.g., specific `stdstore` usage patterns found in the repository) or to merge existing content from another internal guidance file.
