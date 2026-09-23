<?php

date_default_timezone_set('America/Los_Angeles');

error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once('_core/class.dmc.php');

$eventsDMC = new EventsDMC(); // optionally pass an alternate root relative path to data folder. Default is "/_resources/data/".

if (str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME'])) && isset($_GET['datasource']) && $_GET['datasource'] != '') {
	get_events_dmc_output(array('endpoint' => true));
}

function get_events_dmc_output($options)
{
	global $eventsDMC;
	return $eventsDMC->get_output($options);
}

class EventsDMC
{

	private $dmc;

	public function __construct($data_folder = null)
	{
		$this->dmc = new DMC($data_folder);
	}

	public function get_output($options)
	{
		$resultSet = $this->dmc->getResultSet($options);
		$templating_function = '';

		switch ($resultSet['meta']['options']['type']) {
			case 'homepage_events':
			$templating_function = 'render_homepage_events';
			$resultSet = $this->remove_past_dates_by_node($resultSet,'end',SORT_ASC);
// 			$resultSet = $this->remove_past_dates($resultSet);
			break;
		}

		//$resultSet = $this->dmc->xpathFilter($resultSet, "node()[name()='FIRST_NAME' or name()='LAST_NAME'][starts-with(text(), 'P')]");
		$resultSet = $this->dmc->search($resultSet);
		$resultSet = $this->dmc->distinct($resultSet);
		$resultSet = $this->dmc->sort($resultSet);
		$resultSet = $this->dmc->truncate($resultSet);
		$resultSet = $this->dmc->paginate($resultSet);
		$resultSet = $this->dmc->select($resultSet);

		//echo 'Current PHP version: ' . phpversion();
		echo $this->dmc->render($resultSet, array($this, $templating_function));
	}

	public function render_homepage_events($resultSet)
	{
		$result = '';
		$items = $resultSet['items'];

		foreach ($items as $i => $item) {
			$href = $item->link;
			$title = $item->title;
			$desc = strip_tags($item->description);
			$trunc = 100;
			if (strlen($desc) > $trunc) {
				$desc = wordwrap($desc, $trunc);
				$desc = substr($desc, 0, strpos($desc, "\n"));
				$desc.= "...";
			}
			$start = $item->start;
			$end = $item->end;
			$month = date('M', strtotime($end));
			$day = date('d', strtotime($start));
			$year = date('Y', strtotime($end));
			$hour = date('g:iA', strtotime($start));

			$result .= '<div class="event-item">';
			$result .= '<div class="event-date">';
			$result .= '<div class="event-date-bg">';
			$result .= '<span class="event-month">' . $month . '</span>';
			$result .= '<span class="event-day">' . $day . '</span>';
			$result .= '<span class="year">' . $year . '</span>';
			$result .= '</div>';
			$result .= '</div>';
			$result .= '<div class="event-text">';
			$result .= '<h3 class="event-title"><a href="' . $href . '">' . $title . '</a></h3>';
			if($hour!='12:00AM') {
				$result .= '		<div class="event-item-time"><span class="time">' . $hour . '</span></div>';
			}
			else {
				$result .= '		<div class="event-item-time"><span class="time">All Day</span></div>';
			}
			$result .= '<div class="event-item-copy">';
			$result .= '<p>' . $desc . '</p>';
			$result .= '</div>';
			$result .= '</div>';
			$result .= '</div>';

		}

		return $result;
	}

	private function remove_past_dates($resultSet)
	{
		$result_items = array();
		$now = new DateTime('today'); // begining of the current day

		foreach($resultSet['items'] as $i){
			$date = new DateTime($i->end);

			if($date > $now) $result_items[] = $i;
		}

		$resultSet['items'] = $result_items;
		$resultSet['meta']['total'] = count($resultSet['items']);

		return $resultSet;
	}
	
		private function remove_past_dates_by_node($resultSet, $node = "pubDate", $sort = SORT_ASC){
		$result_items = array();
		$now = new DateTime('now', new DateTimeZone(date_default_timezone_get()));
		$node = str_replace('cal:','',$node);

		foreach($resultSet['items'] as $i){
			$date = new DateTime($i->$node, new DateTimeZone('UTC'));
			$date->setTimezone( new DateTimeZone(date_default_timezone_get()) );
			if($date->format('Y-m-d H:i:s') > $now->format('Y-m-d H:i:s')) $result_items[] = $i;
		}

		$dates = array();
		foreach ($result_items as $key => $row) {
			$time = strtotime($row->$node);
			$dates[$key] = $time;
		}

		array_multisort($dates, $sort, $result_items);

		$resultSet['items'] = $result_items;
		$resultSet['meta']['total'] = count($resultSet['items']);

		return $resultSet;
	}

	private function get_distinct_list($resultSet, $xpath)
	{
		$options = array();
		$options['datasource'] = $resultSet['meta']['options']['datasource'];
		$options['xpath'] =  $xpath;

		$result = $this->dmc->getResultSet($options);

		return $result['items'];
	}
}
?>