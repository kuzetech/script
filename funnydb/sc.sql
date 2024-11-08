SELECT 
  dictGet('shu_ju_shou_ji_tong_ji_guo_nei_efsac21b.dict_tp_access_key', 'app_identifier', `accessKeyId`) as app,
  toStartOfHour(toDateTime(begin_time / 1000)) AS start_of_hour,
  sum(report_total) as total
FROM events
WHERE `#event` = 'collector_report_status'
AND begin_time >= toUnixTimestamp64Milli(toDateTime64(toStartOfDay(yesterday()), 3))
AND end_time <= toUnixTimestamp64Milli(toDateTime64(toStartOfDay(yesterday() + 1), 3))
AND accessKeyId IS NOT NULL
GROUP BY start_of_hour, app
ORDER BY app asc, start_of_hour asc



SELECT 
  app,
  toStartOfHour(toDateTime(begin_time / 1000)) AS start_of_hour,
  sum(report_total) as total
FROM events
WHERE `#event` = 'collector_report_status'
AND begin_time >= toUnixTimestamp64Milli(toDateTime64(toStartOfDay(yesterday()), 3))
AND end_time <= toUnixTimestamp64Milli(toDateTime64(toStartOfDay(yesterday() + 1), 3))
AND `#sdk_type` = 'time_job'
GROUP BY start_of_hour, app
ORDER BY app asc, start_of_hour asc