<?php
/** Reusable RSS cards. Request-local memoization only; no filesystem writes. */
function ltcc_feed_escape($value) {
    return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}
function ltcc_feed_url($value) {
    $value = trim((string)$value);
    return preg_match('~^https?://~i', $value) && filter_var($value, FILTER_VALIDATE_URL) ? $value : '';
}
function ltcc_feed_fetch($url) {
    static $responses = [];
    // The bare LTCC hostname redirects to www; use its canonical feed URL.
    $url = preg_replace('~^https://ltcc\.edu(?=[:/]|$)~i', 'https://www.ltcc.edu', $url);
    if (array_key_exists($url, $responses)) return $responses[$url];
    $responses[$url] = null;
    $parts = parse_url($url);
    // Feed destinations are fixed services, not arbitrary server-side URLs.
    if (!$parts || ($parts['scheme'] ?? '') !== 'https' || !in_array(strtolower($parts['host'] ?? ''), ['ltcc.edu', 'www.ltcc.edu', 'api.calendar.moderncampus.net'], true)
        || isset($parts['user']) || isset($parts['pass']) || (isset($parts['port']) && $parts['port'] !== 443)) return null;
    $body = '';
    if (function_exists('curl_init')) {
        $ch = curl_init($url);
        curl_setopt_array($ch, [CURLOPT_CONNECTTIMEOUT => 3, CURLOPT_TIMEOUT => 6, CURLOPT_FOLLOWLOCATION => false,
            CURLOPT_USERAGENT => 'LTCC Feed Components', CURLOPT_WRITEFUNCTION => function ($ch, $chunk) use (&$body) {
                if (strlen($body) + strlen($chunk) > 5 * 1024 * 1024) return 0;
                $body .= $chunk; return strlen($chunk);
            }]);
        $ok = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if (!$ok || $status !== 200) return null;
    } else {
        $context = stream_context_create(['http' => ['timeout' => 6, 'follow_location' => 0, 'user_agent' => 'LTCC Feed Components']]);
        $body = @file_get_contents($url, false, $context, 0, 5 * 1024 * 1024 + 1);
        if ($body === false || strlen($body) > 5 * 1024 * 1024) return null;
    }
    return $responses[$url] = $body;
}
function ltcc_feed_date($value, $timezone) {
    $value = trim((string)$value);
    if ($value === '') return null;
    try { return (new DateTimeImmutable($value, $timezone))->setTimezone($timezone); }
    catch (Exception $e) { return null; }
}
function ltcc_feed_items($xml, $kind, array $options, $now = null) {
    if (!is_string($xml) || stripos($xml, '<!DOCTYPE') !== false) return null;
    $previous = libxml_use_internal_errors(true);
    $rss = simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NONET | LIBXML_NOCDATA);
    libxml_clear_errors(); libxml_use_internal_errors($previous);
    if (!$rss || !isset($rss->channel)) return null;
    $timezone = new DateTimeZone('America/Los_Angeles');
    $now = $now ?: new DateTimeImmutable('now', $timezone);
    $items = [];
    $seen = [];
    foreach ($rss->channel->item as $item) {
        $title = trim((string)$item->title);
        $url = ltcc_feed_url($item->link);
        if ($title === '' || $url === '') continue;
        $image = ''; $end = null; $allDay = false;
        if ($kind === 'events') {
            $cal = $item->children('https://moderncampus.com/Data/cal/');
            if (strtoupper(trim((string)$cal->status)) === 'CANCELLED') continue;
            if (($options['featured'] ?? '') === 'true' && strtolower(trim((string)$cal->featured)) !== 'true') continue;
            $organizer = trim($options['organizer'] ?? '');
            if ($organizer !== '' && strcasecmp($organizer, trim((string)$cal->organizer)) !== 0) continue;
            $date = ltcc_feed_date($cal->start, $timezone);
            if (!$date) continue;
            $allDay = preg_match('/^\d{4}-\d{2}-\d{2}$/', trim((string)$cal->start)) === 1;
            $end = ltcc_feed_date($cal->end, $timezone) ?: $date;
            // Date-only events stay visible through their stated end date.
            if ($allDay) $end = $end->setTime(23, 59, 59);
            if ($end < $now) continue;
            $key = (trim((string)$cal->guid) ?: $url) . '|' . $date->format(DATE_ATOM);
        } else {
            $date = ltcc_feed_date($item->pubDate, $timezone);
            if (!$date || $date > $now) continue;
            $media = $item->children('http://search.yahoo.com/mrss/');
            $image = isset($media->content) ? ltcc_feed_url((string)$media->content->attributes()['url']) : '';
            if ($image === '' && isset($media->thumbnail)) $image = ltcc_feed_url((string)$media->thumbnail->attributes()['url']);
            $key = $url;
        }
        if (isset($seen[$key])) continue;
        $seen[$key] = true;
        $items[] = compact('title', 'url', 'image', 'date', 'end', 'allDay');
    }
    usort($items, function ($a, $b) use ($kind) { return $kind === 'events' ? $a['date'] <=> $b['date'] : $b['date'] <=> $a['date']; });
    return array_slice($items, 0, max(1, min(50, (int)($options['max-items'] ?? 6))));
}
function ltcc_render_feed_component(array $options) {
    $kind = ($options['kind'] ?? '') === 'events' ? 'events' : 'news';
    $feed = trim($options['feed-url'] ?? '');
    if ($feed === '') $feed = $kind === 'news' ? 'https://www.ltcc.edu/rss/news.xml' : 'https://api.calendar.moderncampus.net/pubcalendar/820f2290-4714-43f1-a00f-c8373f784878/rss?url=https%3A%2F%2Fwww.ltcc.edu%2Fcalendar%2Findex.php&hash=true';
    try { $items = ltcc_feed_items(ltcc_feed_fetch($feed), $kind, $options); }
    catch (Throwable $e) { $items = null; error_log('LTCC feed component: ' . $e->getMessage()); }
    if ($items === null) {
        echo '<p class="mb-0">' . ($kind === 'news' ? 'News' : 'Events') . ' is temporarily unavailable. <a href="' . ($kind === 'news' ? '/news/' : '/calendar/index.php') . '">View all ' . $kind . '</a>.</p>';
        return;
    }
    if (!$items) { echo '<p class="mb-0">No ' . ($kind === 'events' ? 'upcoming events' : 'news stories') . ' match these settings.</p>'; return; }
    ltcc_render_feed_cards($items, $kind, $options);
}
function ltcc_render_feed_cards(array $items, $kind, array $options) {
    $counts = [];
    foreach (['mobile' => 1, 'tablet' => 2, 'desktop' => 3] as $screen => $default) {
        $counts[$screen] = max(1, min(6, (int)($options['items-' . $screen] ?? $default)));
    }
    echo '<section class="ltcc-feed-carousel ' . ($kind === 'news' ? 'news-carousel' : 'events-carousel') . '" aria-label="' . ($kind === 'news' ? 'Latest news' : 'Upcoming events') . '" data-feed-carousel=""';
    foreach ($counts as $screen => $count) echo ' data-items-' . $screen . '="' . $count . '"';
    echo ' style="--feed-mobile:' . $counts['mobile'] . ';--feed-tablet:' . $counts['tablet'] . ';--feed-desktop:' . $counts['desktop'] . '"><div class="swiper"><div class="swiper-wrapper">';
    foreach ($items as $item) {
        echo '<div class="swiper-slide"><article class="card h-100 ' . ($kind === 'events' ? 'card-event p-4' : 'overflow-hidden') . '">';
        if ($kind === 'news') {
            if ($item['image'] !== '') echo '<img class="card-img-top" src="' . ltcc_feed_escape($item['image']) . '" alt="" loading="lazy" decoding="async">';
            echo '<div class="card-body p-4 d-flex flex-column align-items-start">';
        }
        echo '<h3 class="fs-5 mb-4"><a class="stretched-link text-decoration-none" href="' . ltcc_feed_escape($item['url']) . '">' . ltcc_feed_escape($item['title']) . '</a></h3><div class="d-flex flex-wrap gap-2 mt-auto fs-8 fw-semibold">';
        $dateLabel = $item['date']->format('n/j/Y');
        if ($kind === 'events' && $item['end']->format('Y-m-d') !== $item['date']->format('Y-m-d')) $dateLabel .= ' – ' . $item['end']->format('n/j/Y');
        echo '<time class="rounded-pill bg-gray-200 p-2" datetime="' . $item['date']->format($item['allDay'] ? 'Y-m-d' : DATE_ATOM) . '"><span class="fa-sharp fa-regular fa-calendar-days" aria-hidden="true"></span> ' . ltcc_feed_escape($dateLabel) . '</time>';
        if ($kind === 'events') echo '<span class="rounded-pill bg-gray-200 p-2"><span class="fa-sharp fa-regular fa-clock" aria-hidden="true"></span> ' . ($item['allDay'] ? 'All Day' : $item['date']->format('g:i A T')) . '</span>';
        echo '</div>' . ($kind === 'news' ? '</div>' : '') . '</article></div>';
    }
    echo '</div></div><div class="ltcc-feed-carousel__controls text-end mt-3" hidden><div class="media-controls align-items-center rounded-pill p-1" role="group" aria-label="' . ucfirst($kind) . ' controls">';
    foreach (['prev' => ['Previous items', 'arrow-left'], 'next' => ['Next items', 'arrow-right'], 'pause' => ['Pause slideshow', 'circle-pause']] as $action => $control) {
        echo '<button type="button" class="btn media-playback-toggle rounded-circle" data-feed-' . $action . ' aria-label="' . $control[0] . '"' . ($action === 'pause' ? ' aria-pressed="false"' : '') . '><span class="fa-sharp fa-regular fa-' . $control[1] . '" aria-hidden="true"></span></button>';
    }
    echo '</div></div></section>';
}
