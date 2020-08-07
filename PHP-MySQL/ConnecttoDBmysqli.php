<?php
$servername = "localhost";
$username = "root";
$password = "";

// Create connection
$conn = new mysqli_connect($servername, $username, $password);

// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully";
?>
