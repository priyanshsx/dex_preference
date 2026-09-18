# Whale vs. Retail DEX Execution & Liquidity Preference

This repository contains the data engineering pipeline and visual analytics for evaluating decentralized exchange (DEX) execution quality, specifically comparing institutional-size routing preferences against a zero-impact retail baseline. 

Check out the public Tableau dashboard [here](https://public.tableau.com/views/DEXPreferenceAnalysis/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link). 

# Methodology

## Data Extraction & Pipeline
The foundational dataset was extracted from the dex.trades spellbook on Dune Analytics, capturing Ethereum mainnet transactions from July 2025 to September 2026. The scope was strictly limited to 12 highly liquid pools across Uniswap v3, SushiSwap, and Curve (primarily ETH/USDC, ETH/USDT, and WETH paired stables).

To ensure clean calculations, the Dune SQL query explicitly isolated raw ETH quantities using conditional logic (CASE WHEN token_bought_symbol IN ('ETH', 'WETH')...) rather than relying on blended token counts. All trades were grouped into a weekly chronological timeframe.

## Trade Segmentation (Size Buckets)
To measure price impact accurately, every swap was categorized by its USD execution value:

0.5k–1k (The Baseline): Retail trades small enough to execute with near-zero slippage. This serves as the true market spot price.

1k–10k & 10k–100k: Mid-tier trade execution.

100k+ (The Whales): Large-size trades that consume significant automated market maker (AMM) liquidity and suffer measurable price impact.

## VWAP Calculation (DuckDB)
The aggregated weekly data was processed locally using DuckDB. Rather than relying on simple averages, the true execution cost was determined by calculating the Volume-Weighted Average Price (VWAP). This was achieved by dividing the total weekly USD volume by the total weekly pure ETH volume (SUM(total_volume_usd) / SUM(total_eth_volume)) for each specific venue and size bucket.

# Analytical Insights

## Uniswap v3 0.05% Tier Monopolizes Whale Volume
Despite the fragmentation of liquidity across multiple fee tiers and protocols, institutional-sized volume is overwhelmingly concentrated. The Market Share analysis indicates that the Uniswap v3 0.05% fee tier for ETH/USDC processes the vast majority of $100k+ swaps. Whales bypass cheaper tier alternatives (like 0.01%) and competitors (Curve, SushiSwap) almost entirely, signaling that absolute liquidity depth is the primary driver of routing decisions.  
PNG

## The Execution Spread (Slippage Penalty)
By plotting the 100k+ VWAP directly against the 0.5k-1k retail baseline, the dashboard visually isolates the slippage penalty. During periods of low market volatility, the gap between the whale execution price and the retail baseline remains remarkably tight on deep pools. However, during market stress events, the spread visibly widens as massive orders chew through the concentrated liquidity ranges, forcing whales to accept worse fill prices to complete their block trades.
