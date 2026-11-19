<?php
require_once($_SERVER['DOCUMENT_ROOT'].'/_resources/php/wnl/WNL.php');
$t = new WNL($feed,"/rss/channel/item");

function displayNews($x, $cat = array("All")){
	$y = new CategoryRssItem($x);

	if (strlen($y->murl) < 1)
	{
		$y->murl = "/_resources/img/gallery-1.jpg";
	}

    $title = htmlspecialchars($y->title, ENT_QUOTES, 'UTF-8');
    $href = htmlspecialchars($y->link, ENT_QUOTES, 'UTF-8');
    $image = htmlspecialchars($y->murl, ENT_QUOTES, 'UTF-8');
	$res = "";
	$res .= '<article class="row gy-3 mb-5">';
	$res .= '	<figure class="col-12 col-md-4 mb-0"><img class="img-fluid" src="' . $image . '" alt="' . $title . '" width="250" height="175" /> </figure>';
	$res .= '	<div class="col-12 col-md-8">';
	$res .= '		<h3><a href="' . $href . '" title="Read more">' . $title . '</a></h3>';
	$date_link = date("Y-m-d", strtotime($y->pubDate)); 
	$date = date("F j, Y", strtotime($y->pubDate)); 
	$res .= '		<time datetime="' . $date_link . '">' . $date . '</time>';
	$res .= '			<p>' . $y->description . '</p>';
	$res .= '			<a href="' . $href . '" class="arrow-link">More Info</a>';
	$res .= '	</div>';
	$res .= '</article>';

	echo($res);
}

// set default category/page
if (!isset($cat)) { $cat = "All"; }
$page = 1;

// get values from query string if present
if (intval($_GET['page'] ?? 1) > 0) { $page = intval($_GET['page'] ?? 1); }
if (strlen(is_string($_GET['cat'] ?? null) ? $_GET['cat'] : '') > 0) { $cat = $_GET['cat']; }

// convert the display category to an array
$cat_arr = array($cat);

$num_items = max(1, intval($num_items));

// display the current page of news
$t->Iterate('displayNews', intval($num_items), $cat_arr, $page);

// display the pagination itself (optional), can be in separate file
echo '<nav aria-label="News pages">';
echo '<ul class="pagination flex-wrap gap-1">';
$t->DisplayPagination($page, intval($num_items), $cat);
echo '	</ul>';

echo '</nav>';
?>
