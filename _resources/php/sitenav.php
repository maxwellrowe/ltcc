<?php
// Show all errors
// error_reporting(E_ALL);

parse_str($_SERVER['QUERY_STRING'], $result);

$leftnav = $result['leftnav'];
$leftnav = (isset($leftnav)) ? $leftnav : "/_nav.inc";
// echo "<br/> **********";
// echo "<br/>Left Nav: " . $leftnav . "<br/>";
$serverFilePath = $_SERVER["DOCUMENT_ROOT"] . $currentDirectory . $leftnav;
// echo "<br/>Server File Path: " . $serverFilePath . "<br/>";
// echo "<br/>Current Directory Before Replace: " . $currentDirectory . "<br/>";
$currentDirectory = str_replace("_nav.inc", "", $currentDirectory);
// echo "<br/>Current Directory After Replace: " . $currentDirectory . "<br/>";
$nestLevel = 1;
// echo "<br/>Nest Level: " . $nestLevel . "<br/>";

$html = "<ul>";
$allDemHrefs = array();

processNavFile($serverFilePath);

$html .= "</ul>";

echo $html;

// print_r($allDemHrefs);

function processNavFile($filePath){
	global $nestLevel;
	$nestLevel++;

	if(file_exists($filePath)){
		$file = file_get_contents($filePath);
		$regex = '/(<li[^>]*?>[\s]*?<a[^>]*?href="([^"]+?)"(.*?)>[\s\S]*?<\/a>[\s]*?<\/li>)/';

		if(preg_match($regex, $file))
			preg_replace_callback($regex,"matchLI",$file);
	}

	$nestLevel--;
}

function matchLI($matches){
	global $html;
	global $allDemHrefs;
	
	$li = $matches[0];
	$regex = '/<li[^>]*?>[\s]*?<a[^>]*?href=\"([^"]*?\/)(index\.php)?\"[^>]*?>([\s\S]*?)<\/a>[\s]*?<\/li>/';

	preg_match($regex, $li, $link);
	$href = $link[1];
	

	if(preg_match($regex, $li))
		preg_replace_callback($regex,"matchSectionLI",$li);
	else
		$html .= $li;
}

function matchSectionLI($matches){
	global $html;
	global $currentDirectory;
	global $nestLevel;
	global $allDemHrefs;

	$li = $matches[0];
	$href = $matches[1];
	$page = $matches[2];
	$title = $matches[3];

	$filePath = $_SERVER["DOCUMENT_ROOT"] . $href . "_nav.inc";
	$processSubnav = true;

	//check if file exists and contains no list
	if(file_exists($filePath)){
		$file = file_get_contents($filePath);
		$regex = '/(<li[^>]*?>[\s]*?<a[^>]*?>[\s\S]*?<\/a>[\s]*?<\/li>)/';
		// echo "<br/>File Check Process " . $processSubnav;
		if(!preg_match($regex, $file)) {
			$processSubnav = false;
		}
	}
	else
		$processSubnav = false;	//no _nav in section

	// echo "<br/>next set";
	
	//check if this is the current sections index page link
	if(!strcmp($href, $currentDirectory))
		$processSubnav = false;

	//check if class=ou-no-subnav within the li's node
	if(strpos($li, "class=\"ou-no-subnav\"") !== false)
		$processSubnav = false;

	if($nestLevel > 2)
		$processSubnav = false;

	//check if we're attempting to process a nav file in a parent directory
	//if current li > href exists in array $processSubnav = false;
	if(in_array($href, $allDemHrefs))
		$processSubnav = false;

	if($processSubnav){
		// echo "<br/>Process " . $processSubnav;
		
		//add each item to array
		if($href != '')
			array_push($allDemHrefs, $href);

		$html .= "<li><a class=\"x\" href=\"{$href}{$page}\">{$title}</a><a href=\"\" title=\"Expand\" class=\"expand\"><i class=\"fa fa-caret-down\"></i></a><div><ul class=\"{$class}\">";

		$currentDirectory = $href;

		processNavFile($filePath);

		$html .= "</ul></div></li>";
	}
	else {
		// echo "<br/>inside else";
		$html .= $li;	//just copy the li
	}
}

?>
