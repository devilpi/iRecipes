<!DOCTYPE html>
<html>
<head>
	<title>></title>
</head>
<body>


<?php  
$con = mysql_connect("us-cdbr-iron-east-04.cleardb.net","b18b3763eadec5","9e99bd89");  
if (!$con)  
  {  
  die('Could not connect: ' . mysql_error());  
  }  
  
mysql_select_db("ad_7cd90a243a69c36", $con);  
$result = mysql_query("UPDATE vote SET num=num+1 WHERE id=1");  
echo $result;  
mysql_close($con);  
?> 

</body>
</html>