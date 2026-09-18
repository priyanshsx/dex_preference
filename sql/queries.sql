-- borrowing the merged table from dex-swap project
-- feel free to check out dex-swap repo on my github: @priyanshsx 

CREATE TABLE dex_preference AS 
SELECT 
    merged.week, merged.venue, merged.size_bucket, merged.project_contract_address, merged.swap_count, merged.total_volume_usd, merged.total_eth_volume, merged.tvl_usd, merged.fee_tier,
    vwap_metrics.vwap_price
FROM merged   
LEFT JOIN vwap_metrics
ON merged.week = vwap_metrics.week AND merged.venue = vwap_metrics.venue AND merged.size_bucket = vwap_metrics.size_bucket



