<?php

// error_reporting(-1);
// ini_set('display_errors', 'On');

require_once($_SERVER['DOCUMENT_ROOT'].'/_resources/php/wnl/WNL.php');

if(isset($_GET['cal_feed'])) {
	$cal_feed = $_GET['cal_feed'];	
}

if(isset($_GET['num_cal_items'])) {
	$num_cal_items = $_GET['num_cal_items'];
}									 

date_default_timezone_set('America/Los_Angeles');

$ch = new WNL($cal_feed,"/rss/channel/item");

function displayHomeCal($x, $cat = array("All")){
	$y = new CategoryRssItem($x);		
	
	$desc = strip_tags($y->description);
	$trunc = 100;
	if (strlen($desc) > $trunc) {
		$desc = wordwrap($desc, $trunc);
		$desc = substr($desc, 0, strpos($desc, "\n"));
		$desc.= "...";
	}
	$fixed_date = strtotime(preg_replace('/\s*-\d{4}\s*/', '', $y->pubDate));
	$date = date("l, F j @ g:i a", $fixed_date); 
	$date_attr = date("Y-m-d H:i", $fixed_date); 
	
	$cal_home = '';	
	$cal_home .= '<div class="event-item">';
	$cal_home .= '<div class="event-date">';
	$cal_home .= '<div class="event-date-bg">';
	$cal_home .= '<span class="event-month">' . date('M', $fixed_date) . '</span>';
	$cal_home .= '<span class="event-day">' . date('j', $fixed_date) . '</span>';
	$cal_home .= '<span class="year">' . date('Y', $fixed_date) . '</span>';
	$cal_home .= '</div>';
	$cal_home .= '</div>';
	$cal_home .= '<div class="event-text">';
	$cal_home .= '<h3 class="event-title"><a href="' . $y->link . '">' . $y->title . '</a></h3>';
	$cal_home .= '<div class="event-item-time"><span class="time">' . date('g:i A', $fixed_date) . '</span></div>';
	$cal_home .= '<div class="event-item-copy">';
	$cal_home .= '<p>' . $desc . '</p>';
	$cal_home .= '</div>';
	$cal_home .= '</div>';
	$cal_home .= '</div>';
	
	echo($cal_home);
}

// set default category/page
if (!isset($cat)) { $cat = "All"; }
$page = 1;

// get values from query string if present
// if (intval($_GET['page']) > 0) { $page = intval($_GET['page']); }
// if (strlen($_GET['cat']) > 0) { $cat = $_GET['cat']; }

//Get the number of items to display
$ch->items = $ch->Take($num_cal_items);

// display the current page of news
$ch->IterateAll('displayHomeCal');

?>
