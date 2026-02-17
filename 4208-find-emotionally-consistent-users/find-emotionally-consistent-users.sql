# Write your MySQL query statement below

WITH user_stats AS (
    SELECT 
        user_id,
        reaction,
        COUNT(*) AS cnt,
        SUM(COUNT(*)) OVER (PARTITION BY user_id) AS total
    FROM reactions
    GROUP BY user_id, reaction
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY cnt DESC) AS rn
    FROM user_stats
    WHERE total >= 5
)
SELECT 
    user_id,
    reaction AS dominant_reaction,
    ROUND(cnt / total, 2) AS reaction_ratio
FROM ranked
WHERE rn = 1 AND cnt / total >= 0.6
ORDER BY reaction_ratio DESC, user_id;