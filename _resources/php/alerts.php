<?php
/** Request-time alert scheduling. Unzoned CMS dates use campus local time. */
function ltcc_alert_visible($display, $start = '', $end = '', $now = null)
{
    if ($display === 'always') return true;
    if ($display !== 'scheduled') return false;
    $zone = new DateTimeZone('America/Los_Angeles');
    $parse = static function ($value) use ($zone) {
        $value = trim($value);
        if ($value === '') return null;
        // Modern Campus date/time fields use MM/DD/YYYY h:mm AM/PM.
        // Normalize to local ISO time, then apply the same strict validation below.
        if (preg_match('/^(\d{1,2})\/(\d{1,2})\/(\d{4})\s+(\d{1,2}):(\d{2})\s+(AM|PM)$/iD', $value, $parts)) {
            $hour = (int) $parts[4];
            if ($hour < 1 || $hour > 12 || (int) $parts[5] > 59) return false;
            $hour = $hour % 12 + (strtoupper($parts[6]) === 'PM' ? 12 : 0);
            $value = sprintf('%04d-%02d-%02dT%02d:%02d', $parts[3], $parts[1], $parts[2], $hour, $parts[5]);
        }
        // Accept datetime-local / ISO input, optionally with seconds and timezone.
        if (!preg_match('/^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}(:\d{2})?(Z|[+-]\d{2}:\d{2})?$/D', $value)) return false;
        try {
            $date = new DateTimeImmutable($value, $zone);
            $errors = DateTimeImmutable::getLastErrors();
            if ($errors && ($errors['warning_count'] || $errors['error_count'])) return false;
            // Reject normalized invalid times, including nonexistent local DST times.
            if ($date->format('Y-m-d H:i') !== str_replace('T', ' ', substr($value, 0, 16))) return false;
            return $date;
        } catch (Exception $error) {
            return false;
        }
    };
    $from = $parse($start);
    $until = $parse($end);
    if ($from === false || $until === false || ($from && $until && $until <= $from)) return false;
    $now = $now ?: new DateTimeImmutable('now', $zone);
    return (!$from || $now >= $from) && (!$until || $now < $until);
}
