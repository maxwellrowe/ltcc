<?php
require __DIR__ . '/../../_resources/php/alerts.php';
$now = new DateTimeImmutable('2026-11-16T12:00:00-08:00');
$cases = [
    ['scheduled', '11/15/2026 11:51 AM', '11/18/2026 11:51 AM', true],
    ['scheduled', '11/16/2026 12:00 PM', '', true],
    ['scheduled', '11/16/2026 12:01 PM', '', false],
    ['scheduled', '', '11/16/2026 12:00 PM', false],
    ['scheduled', '11/16/2026 12:00 AM', '11/17/2026 12:00 AM', true],
    ['scheduled', '1/1/2026 1:00 pm', '', true],
    ['scheduled', '02/30/2026 11:51 AM', '', false],
    ['scheduled', '11/15/2026 00:51 AM', '', false],
    ['scheduled', '11/15/2026 13:51 PM', '', false],
    ['scheduled', '11/15/2026 11:60 AM', '', false],
    ['scheduled', '03/08/2026 2:30 AM', '', false],
    ['always', 'invalid', 'invalid', true], ['hide', '', '', false], ['unknown', '', '', false],
    ['scheduled', '', '', true], ['scheduled', '2026-11-16T12:00', '', true],
    ['scheduled', '2026-11-16 12:01', '', false], ['scheduled', '', '2026-11-16T12:00', false],
    ['scheduled', '', '2026-11-16T12:01', true], ['scheduled', '2026-11-16T11:00', '2026-11-16T13:00', true],
    ['scheduled', '2026-11-16T13:00', '2026-11-16T11:00', false],
    ['scheduled', '2026-11-16T12:00', '2026-11-16T12:00', false],
    ['scheduled', '2026-02-30T12:00', '', false], ['scheduled', 'tomorrow', '', false],
    ['scheduled', '2026-03-08T02:30', '', false], // Nonexistent Pacific DST time.
    ['scheduled', '2026-11-16T20:00:00Z', '', true],
    ['scheduled', '2026-11-16T20:01:00+00:00', '', false],
    ['scheduled', "'); echo 'injected';", '', false],
];
foreach ($cases as $case) {
    [$display, $start, $end, $expected] = $case;
    if (ltcc_alert_visible($display, $start, $end, $now) !== $expected) throw new Exception('Failed: ' . json_encode($case));
}
echo 'PASS: ' . count($cases) . " request-time scheduling cases.\n";
