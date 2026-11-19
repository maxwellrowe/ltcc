<?php
require_once __DIR__ . '/../../_resources/php/feed-components.php';
function check($condition, $message) { if (!$condition) throw new RuntimeException($message); }
function event($title, $start, $end, $featured = 'false', $organizer = 'Campus', $status = 'CONFIRMED') {
    return '<item><title>'.$title.'</title><link>https://www.ltcc.edu/calendar/index.php#'.$title.'</link><pubDate>Mon, 01 Jan 2024 00:00:00 +0000</pubDate><cal:start>'.$start.'</cal:start><cal:end>'.$end.'</cal:end><cal:featured>'.$featured.'</cal:featured><cal:organizer>'.$organizer.'</cal:organizer><cal:status>'.$status.'</cal:status></item>';
}
$xml = '<rss xmlns:cal="https://moderncampus.com/Data/cal/"><channel>' .
    event('Later', '2026-12-01', '2026-12-01', 'true') .
    event('Ongoing', '2026-11-01', '2026-11-30') .
    event('Tonight', '2026-11-19T01:00Z', '2026-11-19T03:00Z', 'true', 'Gallery') .
    event('Past', '2026-10-01', '2026-10-01') .
    event('Cancelled', '2026-12-01', '2026-12-01', 'true', 'Campus', 'CANCELLED') . '</channel></rss>';
$now = new DateTimeImmutable('2026-11-18T12:00:00-08:00');
$items = ltcc_feed_items($xml, 'events', ['max-items'=>6], $now);
check(array_column($items,'title') === ['Ongoing','Tonight','Later'], 'Event dates/order/expired/cancelled');
check($items[1]['date']->format('Y-m-d H:i') === '2026-11-18 17:00', 'UTC converted to Pacific');
check($items[0]['allDay'], 'All day retained');
$filtered = ltcc_feed_items($xml, 'events', ['featured'=>'true','organizer'=>'gallery','max-items'=>1], $now);
check(count($filtered) === 1 && $filtered[0]['title']==='Tonight', 'Filters before maximum, case insensitive organizer');
check(ltcc_feed_items('<broken', 'news', []) === null, 'Bad XML');
check(ltcc_feed_items('<!DOCTYPE rss><rss/>', 'news', []) === null, 'No DTD');
check(ltcc_feed_fetch('http://127.0.0.1/private') === null, 'Disallowed fetch host');
$news = '<rss xmlns:media="http://search.yahoo.com/mrss/"><channel><item><title>Older</title><link>https://www.ltcc.edu/news/a.php</link><pubDate>2026-11-01</pubDate></item><item><title>New &amp; &lt;safe&gt;</title><link>https://www.ltcc.edu/news/b.php?a=1&amp;b=2</link><pubDate>2026-11-10</pubDate><media:content url="https://www.ltcc.edu/photo.jpg"/></item><item><title>Unsafe</title><link>javascript:alert(1)</link><pubDate>2026-11-11</pubDate></item></channel></rss>';
$n = ltcc_feed_items($news,'news',['max-items'=>1],$now);
check(count($n)===1 && $n[0]['title']==='New & <safe>', 'News sort and maximum');
ob_start(); ltcc_render_feed_cards($n,'news',['items-mobile'=>1,'items-tablet'=>2,'items-desktop'=>3]); $html=ob_get_clean();
check(strpos($html,'New &amp; &lt;safe&gt;')!==false && strpos($html,'a=1&amp;b=2')!==false, 'HTML escaping');
check(substr_count($html,'<button')===3 && strpos($html,'media-controls')!==false, 'Shared controls');
check(strpos($html,'alt=""')!==false, 'Decorative news image');
ob_start();ltcc_render_feed_cards($items,'events',[]);$html=ob_get_clean();
check(strpos($html,'All Day')!==false && strpos($html,'5:00 PM PST')!==false, 'Event card dates');
echo "PASS: feed parsing, dates, filters, limits, failure handling, rendering and escaping.\n";
