<?php

// error_reporting(-1);
// ini_set('display_errors', 'On');

require_once($_SERVER['DOCUMENT_ROOT'].'/_resources/php/wnl/WNL.php');
$num_cal_items=6;
$cal_feed="/calendar/rss/feed.php";
date_default_timezone_set('America/Los_Angeles');

$ch = new WNL($cal_feed,"/rss/channel/item");

function displayHomeCal($x){
	$y = new CategoryRssItem($x);		
	
	$desc = strip_tags($y->description);
	$trunc = 100;
	if (strlen($desc) > $trunc) {
		$desc = wordwrap($desc, $trunc);
		$desc = substr($desc, 0, strpos($desc, "\n"));
		$desc.= "...";
	}	
	$date = date("l, F j @ g:i a", strtotime($y->pubDate)); 
	$date_attr = date("Y-m-d H:i", strtotime($y->pubDate)); 
	$cal_home = "";	
	/*
		<li>
				<a href="#" title=""><time datetime="2015-09-10 14:00">Friday, October 9 @ 2:00 pm</time></a>
				<strong>Men's Soccer Game</strong>
				<span>LTCC vs. Butte</span>
		</li>
	*/
	try {
		$cal_home .= '<li>';
		$cal_home .= '	<a href="' . $y->link . '"><time datetime="' . $date_attr . '">' . $date . '</time></a>';		
		$cal_home .= '	<strong>' . $y->title . '</strong>';	
		$cal_home .= '	<span>' . $desc . '</span>';	
		$cal_home .= '</li>';
	} catch (Exception $e) {
		echo '<li>No calendar events available. Please check back later.</li>';
	}	
	echo($cal_home);
}

// set default category/page

$page = 1;

// get values from query string if present
// if (intval($_GET['page']) > 0) { $page = intval($_GET['page']); }
// if (strlen($_GET['cat']) > 0) { $cat = $_GET['cat']; }


$ch->items = $ch->Take($num_cal_items);
// display the current page of news
$ch->IterateAll('displayHomeCal');

?>
