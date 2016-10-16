<?php
function get($paramName){
    if (is_array($_POST) && count($_POST) > 0) {
        if(isset($_POST[$paramName])) {
            return $_POST[$paramName];
        }
    }
    return "";
}


$name = get("name");
$description = get("description");
$url = "";   //api
$category = parseCateS(get("category"));
$kind = parseKindS(get("kind"));
$potein = get("protein");
$vitamin = get("vitamin");
$calorie = get("calorie");
function parseCateS($cate){
    switch ($cate){
        case "mainFood": {return 1;
            break;
        }
        case "fruit&vege": {return 2;
            break;
        }
        case "meat": {return 3;
            break;
        }
        case "egg&milk": {return 4;
            break;
        }
        case "other": {return 5;
            break;
        }
        default:
            return null;
    }
}
function parseKindS($kind){
    switch ($kind){
        case "rice":
            {
            return 1;
            break;
        }
        case "noodle":{
            return 2;
            break;
        }
        case "vegetable":{
            return 1;
            break;
        }
        case "fruit":{
            return 2;
            break;
        }
        case "landmeat":{
            return 1;
            break;
        }
        case "fish":{
            return   2;
            break;

        }
        case "milk" :{
            return   1       ;
            break;

        }

        case "egg" :{
            return    2    ;
            break;

        }
        case "other":{
            return    1;
            break;

        }
        default:return null;

    }
}
$con = new mysqli("us-cdbr-iron-east-04.cleardb.net","b18b3763eadec5","9e99bd89","ad_7cd90a243a69c36");
if (mysqli_connect_errno()) {
    $a = array();
    $a["success"] = 0;
    $arr = json_encode($a);
    echo $arr;
    die(mysqli_connect_error());
}

$id = 1;
$sql = "select * from food";
$result=mysqli_query($con, $sql);

while (mysqli_fetch_array($result, MYSQLI_ASSOC))
    $id++;

$sql = "INSERT INTO food VALUES (\"$id\", \"$name\", \"$description\", \"$url\", \"$category\", \"$kind\", \"$potein\", \"$vitamin\", \"$calorie\")";

$con->query($sql);
$con->close();

$a = array();
$a["success"] = 1;
$arr = json_encode($a);
echo $arr;

?>