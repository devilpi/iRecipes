<?php
/**
 * Created by PhpStorm.
 * User: xk
 * Date: 2016/10/15
 * Time: 23:30
 */
function get($paramName){
    if (is_array($_GET) && count($_GET) > 0) {
        if(isset($_GET[$paramName])) {
            return $_GET[$paramName];
        }
    }
    return "";
}
function parseCate($cate){
    switch ($cate){
        case 1: {return "mainFood";
            break;
        }
        case 2: {return "fruit&vege";
            break;
        }
        case 3: {return "meat";
            break;
        }
        case 4: {return "egg&milk";
            break;
        }
        case 5: {return "other";
            break;
        }
        default:
            return null;
    }
}


function parseKind($cate,$value){
    switch ($cate*10 + $value){
        case 11:{
            return "rice";
            break;
        }
        case 12:{
            return "noodle";
            break;
        }
        case 21:{
            return "vegetable";
            break;
        }
        case 22:{
            return "fruit";
            break;
        }
        case 31:{
            return "landmeat";
            break;
        }
        case 32:{
            return      "fish"     ;
            break;

        }
        case 41:{
            return "milk"          ;
            break;

        }

        case 42:{
            return     "egg"    ;
            break;

        }
        case 51:{
            return        "other"   ;
            break;

        }
        default:return null;

    }
}

    $name = get("name");
    $con = new mysqli("us-cdbr-iron-east-04.cleardb.net","b18b3763eadec5","9e99bd89","ad_7cd90a243a69c36");
    if (mysqli_connect_errno()) {
        $a = array();
        $a["success"] = 0;
        $arr = json_encode($a);
        echo $arr;
        die(mysqli_connect_error());
    }
    $con->query("SET NAMES UTF8");
    $sql = "SELECT * FROM food WHERE name LIKE '%$name%'";
    echo $sql;
    $result = mysqli_query($con,$sql);

    $number = 0;
    $a = array();
    $a["success"] = 1;
    $tmp = array();
    $data = array();
    while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)){
        $number++;
        $tmp["id"]=$row["id"];
        $tmp["name"] = $row["name"];
        $tmp["description"] = $row["description"];
        $tmp["imageURL"] = $row["imageURL"];
        $tmp["category"] = parseCate($row["category"]);
        $tmp["kind"] = parseKind($row["category"],$row["kind"]);
        $tmp["potein"] = $row["potein"];
        $tmp["vitamin"] = $row["vitamin"];
        $tmp["calorie"] = $row["calorie"];
        $data[]= $tmp;
    }
    $a["data"] = $data;
    $a["number"]=$number;
    $arr = json_encode($a);
    echo $arr;
    $con->close();

