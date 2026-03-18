select currentDatabase();

formatDateTime(fromUnixTimestamp64Milli(`#created_time`), '%Y-%m-%d %H:%i:%s.%f', 'Asia/Shanghai')

SELECT
    multiIf(
    `#duration` < 0, '小于0',
    `#duration` = 0, '等于0',
    '大于0'
    ) AS duration_group,
    count() AS num,
    sum(count()) OVER () AS total,
    round(count() * 100 / total, 2) AS ratio
FROM events
WHERE `#dt` = '2026-01-14'
AND `#event` = '#user_online_duration'
AND `#sdk_type` = 'flink-derive'
GROUP BY duration_group;


select event 
from xiang_chang_hai_wai_zheng_shi_fu_488tfseh.events_receive_log
where event LIKE 'gameserver%'
AND formatDateTime(fromUnixTimestamp64Milli(`process_time`), '%Y-%m-%d', 'Asia/Shanghai') = '2026-03-18'
AND event GLOBAL NOT in (
  select event
  from xiang_chang_fu_wu_duan_go_sdk_qian_yi_xiao_bi3g7eve.events_receive_log
  where event LIKE 'gameserver%'
  AND formatDateTime(fromUnixTimestamp64Milli(`process_time`), '%Y-%m-%d', 'Asia/Shanghai') = '2026-03-18'
  GROUP BY event
)
GROUP BY event
ORDER BY event desc;