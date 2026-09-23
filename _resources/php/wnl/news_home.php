<?php
require_once($_SERVER['DOCUMENT_ROOT'].'/_resources/php/wnl/WNL.php');
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
	$res .= '<article class="row">';
	$res .= '<li>';
	$res .= '	<figure class="columns small-12 medium-4"><img src="' . $y->murl . '" alt="' . $y->mtitle . '" width="250" height="175" /> </figure>';
	$res .= '	<div class="columns small-12 medium-8">';
	$res .= '		<h3><a href="' . $y->link . '" title="Read more">' . $y->title . '</a></h3>';
	$date_link = date("Y-m-d", strtotime($y->pubDate)); 
	$date = date("F j, Y", strtotime($y->pubDate)); 
	$res .= '		<time datetime="' . $date_link . '">' . $date . '</time>';
	//$desc = substr($y->description, 0, 200);
	$res .= '			<p>' . $desc  . '</p>';
	$res .= '			<a href="' . $y->link . '" class="button" title="Read more">More Info</a>';
	$res .= '	</div>';
    $res .= '<li/>';
	$res .= '</article>';

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
