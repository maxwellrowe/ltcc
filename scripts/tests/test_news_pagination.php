<?php
require_once __DIR__ . '/../../_resources/php/wnl/WNL.php';
function checkNews($condition, $message) {
    if (!$condition) { throw new RuntimeException($message); }
}
$_SERVER['REQUEST_URI'] = '/news/index.php?cat=All';
foreach ([[8, 1, 4, 1], [8, 99, 4, 2], [9, 99, 4, 3], [0, 1, 4, 1], [1, 1, 0, 1], [100, 12, 4, 12]] as [$count, $page, $size, $expected]) {
    $news = (new ReflectionClass(WNL::class))->newInstanceWithoutConstructor();
    $news->items = $count ? array_map(function ($id) { return (object) ['id' => $id, 'pubDate' => gmdate('r', 1794873600 - $id * 86400)]; }, range(0, $count - 1)) : [];
    ob_start();
    $news->DisplayPagination($page, $size, 'All');
    $output = ob_get_clean();
    checkNews(strpos($output, 'class="page-item active" aria-current="page"><span class="page-link">' . $expected . '</span>') !== false, 'Incorrect active page');
    checkNews(strpos($output, '<a href="#"') === false, 'Placeholder pagination link');
    if ($count === 100) { checkNews(strpos($output, 'class="page-item disabled"') !== false, 'Missing ellipsis'); }
    if ($page === 99 && $count === 8) {
        $rendered = [];
        $news->Iterate(function ($item) use (&$rendered) { $rendered[] = $item->id; }, $size, ['All'], $page);
        checkNews($rendered === [4, 5, 6, 7], 'Last page content differs from pagination');
        checkNews(strpos($output, '>Next</a>') === false, 'Next link beyond last page');
    }
}
echo "PASS: six pagination cases, active/disabled markup, and last-page content consistency.\n";
