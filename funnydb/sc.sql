WITH toUnixTimestamp64Milli(toDateTime64(toStartOfHour(toTimeZone(now(), 'Asia/Shanghai')), 3)) AS current_hour_ms
SELECT 
    dictGet('shu_ju_shou_ji_tong_ji_hai_wai_wv20a1hb.dict_tp_access_key', 'app_identifier', `accessKeyId`) as app,
    toStartOfHour(toDateTime(begin_time / 1000, 'Asia/Shanghai')) AS start_of_hour,
    toHour(start_of_hour) as hour,
    sum(report_total) as res
FROM events
WHERE `#event` = 'collector_report_status'
AND begin_time >= (current_hour_ms - 82800000)
AND end_time <= (current_hour_ms + 3600000)
AND accessKeyId IS NOT NULL
GROUP BY app, start_of_hour 
ORDER BY app asc, start_of_hour asc


WITH toUnixTimestamp64Milli(toDateTime64(toStartOfHour(toTimeZone(now(), 'Asia/Shanghai')), 3)) AS current_hour_ms
SELECT 
    app,
    toStartOfHour(toDateTime(begin_time / 1000, 'Asia/Shanghai')) AS start_of_hour,
    toHour(start_of_hour) as hour,
    sum(report_total) as res
FROM events
WHERE `#event` = 'collector_report_status'
AND begin_time >= (current_hour_ms - 82800000)
AND end_time <= (current_hour_ms + 3600000)
AND `#sdk_type` = 'time_job'
GROUP BY app, start_of_hour 
ORDER BY app asc, start_of_hour asc


WITH toUnixTimestamp64Milli(toDateTime64(toStartOfHour(toTimeZone(now(), 'Asia/Shanghai')), 3)) AS current_hour_ms
SELECT 
    ti.app,
    ti.start_of_hour as start_of_hour,
    toHour(ti.start_of_hour) hour,
    ifNull(ti.total, 0) - ifNull(to.total, 0) as res
FROM (
    SELECT 
        dictGet('shu_ju_shou_ji_tong_ji_hai_wai_wv20a1hb.dict_tp_access_key', 'app_identifier', `accessKeyId`) as app,
        toStartOfHour(toDateTime(begin_time / 1000, 'Asia/Shanghai')) AS start_of_hour,
        sum(report_total) as total
    FROM events
    WHERE `#event` = 'collector_report_status'
    AND begin_time >= (current_hour_ms - 82800000)
    AND end_time <= (current_hour_ms + 3600000)
    AND accessKeyId IS NOT NULL
    GROUP BY app, start_of_hour
) as ti
GLOBAL LEFT JOIN (
    SELECT 
        app,
        toStartOfHour(toDateTime(begin_time / 1000, 'Asia/Shanghai')) AS start_of_hour,
        sum(report_total) as total
    FROM events
    WHERE `#event` = 'collector_report_status'
    AND begin_time >= (current_hour_ms - 82800000)
    AND end_time <= (current_hour_ms + 3600000)
    AND `#sdk_type` = 'time_job'
    GROUP BY app, start_of_hour
) as to ON ti.app = to.app AND ti.start_of_hour = to.start_of_hour
ORDER BY app asc, start_of_hour asc


WITH toUnixTimestamp64Milli(toDateTime64(toStartOfHour(toTimeZone(now(), 'Asia/Shanghai')), 3)) AS current_hour_ms
SELECT 
    dictGet('shu_ju_shou_ji_tong_ji_hai_wai_wv20a1hb.dict_tp_access_key', 'app_identifier', `accessKeyId`) as app,
    toStartOfHour(toDateTime(begin_time / 1000, 'Asia/Shanghai')) AS start_of_hour,
    toHour(start_of_hour) as hour,
    uniq(hostname) as total
FROM events
WHERE `#event` = 'collector_report_status'
AND begin_time >= (current_hour_ms - 82800000)
AND end_time <= (current_hour_ms + 3600000)
AND accessKeyId IS NOT NULL
GROUP BY app, start_of_hour
ORDER BY app, start_of_hour