<?php
    /**
     * Created by PhpStorm.
     * User: benbush
     * Date: 2/18/17
     * Time: 1:33 PM
     */
    // Use htmlentities to parse bad strings
    $username = htmlentities($_REQUEST["username"]);
    $password = htmlentities($_REQUEST["password"]);

 
    // Make sure all variables have value
    if (empty($username) || empty($password)) {
        $returnArray["status"] = "400";
        $returnArray["message"] = "Missing required information";
        echo json_encode($returnArray);
        return;
    }

    require 'database.php';

    $stmt = $mysqli->prepare("SELECT username, password, user_id FROM users WHERE username=?");
    

    if (!$stmt) {
        printf("Query Prep Failed: %s\n", $mysqli->error);
    }


    $stmt->bind_param('s', $username);
    $stmt->execute();

    $stmt->bind_result($user, $pass, $id);
    $stmt->fetch();

    if (crypt($password, $pass) == $pass) {
	# Login successful
	$returnArray["status"] = "200";
        $returnArray["message"] = "Login Successful";
	echo json_encode($returnArray);

    } else {
	# Login failed
	$returnArray["status"] = "400";
	$returnArray["message"] = "Password authentication failed";
	echo json_encode($returnArray);
    }
?>
