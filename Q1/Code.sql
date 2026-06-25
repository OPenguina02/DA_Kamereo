-- 1. Best & Least Selling Categories per Channel
WITH f AS (SELECT channel, category, gmv
    FROM sales_data
    WHERE gmv >= 1 AND NOT (category = 'Non-veggie' AND gmv > 70)),
r AS (SELECT *,
           ROW_NUMBER() OVER(PARTITION BY channel ORDER BY gmv DESC) AS br,
           ROW_NUMBER() OVER(PARTITION BY channel ORDER BY gmv ASC)  AS lr FROM f)
SELECT channel,
       MAX(CASE WHEN br=1 THEN category END) AS best_selling_category,
       MAX(CASE WHEN lr=1 THEN category END) AS least_selling_category FROM r
GROUP BY channel;

-- 2. GMV Comparison
SELECT category,
       MAX(CASE WHEN channel='Horeca' THEN gmv END) AS horeca_gmv,
       MAX(CASE WHEN channel='MT' THEN gmv END) AS mt_gmv,
       MAX(CASE WHEN channel='KA' THEN gmv END) AS ka_gmv,
       MAX(CASE WHEN channel='SME' THEN gmv END) AS sme_gmv
FROM sales_data WHERE gmv >= 1 AND NOT (category = 'Non-veggie' AND gmv > 70)
GROUP BY category
ORDER BY category;
