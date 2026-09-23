<?php
ini_set('arg_separator.output','&amp;');
// error_reporting(-1);
// ini_set('display_errors', 'On');
function get_xml_from_url($url){
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13');

    $xmlstr = htmlspecialchars(curl_exec($ch));
    curl_close($ch);

    return $xmlstr;
}

$xmlstr = get_xml_from_url('https://www.ltcc.edu/calendar/rss/wnl.php');
$xmlobj = new SimpleXMLElement(htmlspecialchars($xmlstr));
$xmlobj = (array)$xmlobj;//optional
?>