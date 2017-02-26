<?php
	$mysqli = new mysqli('localhost', 'theMove', 'theMove123', 'root');
	if ($mysqli->onnect_errno) {
		printf("Connection Failed: %s\n", $mysqli->connect_errno);
		exit;
	}

?>
