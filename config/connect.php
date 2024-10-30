<?php
$servername = "localhost";
$username = "root"; 
$password = "";     
$dbname = "docker_db";

// Create connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Verify connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully to docker_db";
?>
