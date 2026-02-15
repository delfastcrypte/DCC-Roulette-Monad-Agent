# DCC Roulette Agent - Moltiverse Hackathon Submission

Autonomous on-chain roulette dealer built for Monad.

## Project Overview
- Token: DCC (0xc1a8907Ae5792Ef8abDd9305Ec0264CA03fD7777) launched on nad.fun.
- Agent manages a simple roulette game: players bet DCC, agent spins (using block-based random), pays winners automatically.
- Fees (house edge) directed to DCC buybacks for holders.
- Built for Gaming Arena bounty in Moltiverse (AI agents wagering on Monad).

## Demo Video
Watch the demo here: https://x.com/DelfastCrypte/status/2022843235719160198

## How it works (basic level)
- Smart contract handles bets (transfer DCC), spin (simple random from block data), and payouts.
- Agent logic: monitors bets, triggers spin when ready, announces results.

## Code
- Solidity contract: See `contracts/DCCRoulette.sol`

## Monad Integration
Deployed on Monad mainnet via nad.fun. Uses EVM for token transfers, on-chain randomness, and low fees/high TPS for real-time gaming.

Submission for Agent + Token Track.
