<?php
require_once($_SERVER['DOCUMENT_ROOT'].'/_resources/php/wnl/WNL.php');

if(isset($_GET['feed'])) {
	$feed = $_GET['feed'];	
}

if(isset($_GET['num_items'])) {
	$num_items = $_GET['num_items'];
}

$t = new WNL($feed,"/rss/channel/item");

function displayNews($x, $cat = array("All")){
	$y = new CategoryRssItem($x);

	if (strlen($y->murl) < 1)
	{
		$y->murl = "/_resources/img/gallery-1.jpg";
	}
	
	$desc = $y->description;
	$trunc = 100;
	if (strlen($desc) > $trunc) {
		$desc = wordwrap($desc, $trunc);
		$desc = substr($desc, 0, strpos($desc, "\n"));
		$desc.= "...";
	}	
	
	$res = "";
	$res .= '<div class="columns small-12 medium-4">';
	$res .= '<div class="card">';
	$res .= '<a href="' . $y->link . '">';
	$res .= '<div class="image-overlay">';
	$res .= '<div class="card-img-top" style="background-image:url(' . $y->murl . ')"></div>';
	$res .= '</div>';
	$res .= '<div class="card-body">';
	$res .= '<h3>' . $y->title . '</h3>';
	$res .= '</div>';
	$res .= '</a>';
	$res .= '</div>';
	$res .= '</div>';
		
	echo($res);
}

// set default category/page
if (!isset($cat)) { $cat = "All"; }
$page = 1;

// get values from query string if present
if (intval($_GET['page']) > 0) { $page = intval($_GET['page']); }
if (strlen($_GET['cat']) > 0) { $cat = $_GET['cat']; }

// convert the display category to an array
$cat_arr = array($cat);

// display the current page of news
$t->Iterate('displayNews', intval($num_items), $cat_arr, $page);

?>
