<?php
	$mysqli = new mysqli('localhost', 'root', 'theMove123', 'theMove');
	if ($mysqli->connect_errno) {
		printf("Connection Failed: %s\n", $mysqli->connect_errno);
		exit;
	}

?>
