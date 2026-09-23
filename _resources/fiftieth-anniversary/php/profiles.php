<?php
	// TURN OFF IN PROD
	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	// CSV to Array Helper Functions
	// Function to convert CSV to Array
	function csv_to_array($file, $delimiter) { 
	  if (($handle = fopen($file, 'r')) !== FALSE) { 
		$i = 0; 
		while (($lineArray = fgetcsv($handle, 4000, $delimiter, '"')) !== FALSE) { 
		  for ($j = 0; $j < count($lineArray); $j++) { 
			$arr[$i][$j] = $lineArray[$j]; 
		  } 
		  $i++; 
		} 
		fclose($handle); 
	  } 
	  return $arr; 
	} 

	// CSV to Array Output -- digests $feed which is a CSV file
	function csv_to_array_output($feed) {
		// Cache Buster
		clearstatcache();
		// Vars
		$keys = array();
		$newArray = array();
		// Call function to convert to CSV
		$data = csv_to_array($feed,',');
		// Set number of elements (minus 1 because we shift off the first row)
		$count = count($data) - 1;
		// Use first row for names  
		$labels = array_shift($data);  
		foreach ($labels as $label) {
			$keys[] = $label;
		}
		// Bring it all together
		for ($j = 0; $j < $count; $j++) {
			$d = array_combine($keys, $data[$j]);
			$newArray[$j] = $d;
		}
		return $newArray;
	}

	// Get Profiles
	function get_profiles($file) {
		$array = csv_to_array_output($file);
		return $array;
	}


	// Profiles Output
	function profiles(
		$style, 
		$file, 
		$filters = '') 
	{
		// Outputs an array of profiles
		$profiles = get_profiles($file);
		
		if($profiles) { 
			if($style == 'grid') { ?>
				<?php if($filters != 'hide-filters') { ?>
					<div class="ltcc-profiles-filter my-3 d-flex justify-content-start gap-2">
						<button class="ltcc-profile-filter-all rounded-1 active">
							All
						</button>
						<button class="rounded-1" data-toggle="type-alumni">
							<span class="bg-green"></span> Alumni
						</button>
						<button class="rounded-1" data-toggle="type-influential">
							<span class="bg-light-blue"></span> Influentials
						</button>
					</div>
				<?php } ?>
				<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
					<?php foreach($profiles as $profile) { 
						// Vars
						$name = $profile['full_name'] ?? '';
						$title = $profile['title'] ?? '';
						$subtitle = $profile['subtitle'] ?? '';
						$bio = $profile['bio'] ?? '';
						$image = $profile['image'] ?? '';
						$type = $profile['type'] ?? '';
						$id = 'profile_' . strtolower(preg_replace('/[^a-z0-9]/', '', $name));

						// bg class
						if($type == 'Alumni') {
							$bg = 'bg-green-tree';
							$color = 'bg-green';
							$border_color = '#007A33';
						} else {
							$bg = 'bg-blue-tree';
							$color = 'bg-light-blue';
							$border_color = '#00A3E0';
						}
					?>
						<div class="col type-<?php echo strtolower($type); ?> ltcc-card-profile-col">
							<a href="#" data-bs-toggle="modal" data-bs-target="#<?php echo $id; ?>" class="ltcc-card-profile card position-relative <?php echo $bg; ?> d-block p-3 p-lg-5 rounded-1" data-aos="fade" data-aos-offset="0">
								<div class="ltcc-card-profile-image position-relative z-3">
									<img src="<?php echo $image; ?>" alt="<?php echo $name; ?>" style="border-color: <?php echo $border_color; ?>;" />
								</div>

								<div class="card-body position-relative z-3 match-height-all text-center">
									<h2 class="fs-2 font-sullivan mt-3"><?php echo $name; ?></h2>
									<p class="ltcc-text-white font-avant">
										<?php echo $title; ?>
										<?php if(!empty($subtitle)) { ?>
											<br /><?php echo $subtitle; ?>
										<?php } ?>
									</p>
								</div>

							</a>
						</div>
					<?php } ?>
				</div>
			<?php } else { ?>
				<div class="swiper ltcc-profile-swiper">
					<div class="swiper-wrapper">
						<?php foreach($profiles as $profile) { 
							// Vars
							$name = $profile['full_name'] ?? '';
							$title = $profile['title'] ?? '';
							$subtitle = $profile['subtitle'] ?? '';
							$bio = $profile['bio'] ?? '';
							$image = $profile['image'] ?? '';
							$type = $profile['type'] ?? '';
							$id = 'profile_' . strtolower(preg_replace('/[^a-z0-9]/', '', $name));

							// bg class
							if($type == 'Alumni') {
								$bg = 'bg-green-tree';
								$color = 'bg-green';
								$border_color = '#007A33';
							} else {
								$bg = 'bg-blue-tree';
								$color = 'bg-light-blue';
								$border_color = '#00A3E0';
							}
						?>
							<div class="swiper-slide type-<?php echo strtolower($type); ?> ltcc-card-profile-col">
								<a href="#" data-bs-toggle="modal" data-bs-target="#<?php echo $id; ?>" class="ltcc-card-profile card position-relative <?php echo $bg; ?> d-block p-3 p-lg-5 rounded-1" data-aos="fade" data-aos-offset="0">
									<div class="ltcc-card-profile-image position-relative z-3">
										<img src="<?php echo $image; ?>" alt="<?php echo $name; ?>" style="border-color: <?php echo $border_color; ?>;" />
									</div>

									<div class="card-body position-relative z-3 match-height-all text-center">
										<h2 class="fs-2 font-sullivan mt-3"><?php echo $name; ?></h2>
										<p class="ltcc-text-white font-avant">
											<?php echo $title; ?>
											<?php if(!empty($subtitle)) { ?>
												<br /><?php echo $subtitle; ?>
											<?php } ?>
										</p>
									</div>

								</a>
							</div>
						<?php } ?>
					</div>
					<div class="swiper-button-next"></div>
					<div class="swiper-button-prev"></div>
				</div>
			<?php } ?>

			<?php // Modals
			foreach($profiles as $profile) { 
				// Vars
				$name = $profile['full_name'] ?? '';
				$title = $profile['title'] ?? '';
				$subtitle = $profile['subtitle'] ?? '';
				$bio = $profile['bio'] ?? '';
				$image = $profile['image'] ?? '';
				$type = $profile['type'] ?? '';
				$id = 'profile_' . strtolower(preg_replace('/[^a-z0-9]/', '', $name));

				// bg class
				if($type == 'Alumni') {
					$bg = 'bg-green-tree';
					$color = 'bg-green';
					$border_color = '#007A33';
				} else {
					$bg = 'bg-blue-tree';
					$color = 'bg-light-blue';
					$border_color = '#00A3E0';
				}	   
			?>
				<div class="modal fade" id="<?php echo $id; ?>" tabindex="-1" aria-label="<?php echo $name; ?>" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered modal-lg ltcc-profile-modal">
						<div class="modal-content bg-dark-blue rounded-1 overflow-auto">
							<div class="modal-body p-0">
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
								<div class="container-fluid">
									<div class="row g-lg-3 me-auto ms-auto mt-3 mt-lg-0">
										<div class="col-12 col-lg-4 pe-lg-0">
											<div class="p-3 pb-lg-4 pe-lg-1">
												<div class="ltcc-card-profile-modal-image rounded-1" style="background-image: url(<?php echo $image; ?>);"></div>
											</div>
										</div>
										<div class="col-12 col-lg-8">
											<div class="p-3 py-lg-3 ps-lg-3">
												<div class="d-flex g-2 justify-content-start align-items-center ltcc-profile-modal-tag">
													<span class="<?php echo $color; ?>"></span> <span class="text-uppercase fw-bold text-light-gray font-avant"><?php echo $type; ?></span>
												</div>
												<h2 class="font-sullivan ltcc-text-white text-uppercase m-0">
													<?php echo $name; ?>
												</h2>
												<p class="ltcc-text-white font-avant">
													<?php echo $title; ?>
													<?php if(!empty($subtitle)) { ?>
														<br /><?php echo $subtitle; ?>
													<?php } ?>
												</p>
												<p class="ltcc-text-white font-avant">
													<?php echo $bio; ?>
												</p>
												<div class="ltcc-text-white font-avant">

												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			<?php } ?>
		<?php } else { ?>
			<p>Sorry, no profiles to show. Check you have included the correct CSV file.</p>
		<?php } ?>
	<?php }
?>