<?php
/**
 * Created by PhpStorm.
 * User: xk
 * Date: 2016/10/15
 * Time: 19:19
 */

function get($paramName)
{
    if (is_array($_GET) && count($_GET) > 0) {
        if (isset($_GET[$paramName])) {
            return $_GET[$paramName];
        }
    }
    return "";
}

$arrUpload = array();
function parseGetJson($getJson) {
    $tmpstr = explode(",", $getJson);
    foreach ($tmpstr as $key => $str) {
        $tmp = "";
        $len = strlen($str);
        for ($i = 0; $i < $len; $i++) {
            $ch = $str[$i];
            if ($ch != '{' && $ch != '}' && $ch != '"' && $ch != '"' && $ch != ' ') {
                $tmp = $tmp . $ch;
            }
        }
        $_GLOBAL['arrUpload'][$key] = $tmp;
    }
}

$getJson = get("data");
parseGetJson($getJson);
$bmi = get("type");

$arr = json_decode($getJson);
//var_dump($getJson);

$count = array();

//var_dump($arr);

$con = new mysqli("us-cdbr-iron-east-04.cleardb.net","b18b3763eadec5","9e99bd89","ad_7cd90a243a69c36");
if (mysqli_connect_errno()) {
    $a = array();
    $a["success"] = 0;
    $arr = json_encode($a);
    echo $arr;
    die(mysqli_connect_error());
}
$a = array();
$a["success"] = 1;

$con->query("SET NAMES UTF8");

foreach ($arrUpload as $key => $item) {
    $sql = "SELECT * FROM food WHERE name = '$item'";
    $result=mysqli_query($con, $sql);
    while ($row=mysqli_fetch_array($result, MYSQLI_ASSOC)){
        $count[$row["category"]][0]++;
        $count[$row["category"]][$count[$row["category"]][0]] = $count[$row["id"]];
        echo  $count[$row["category"]][0] ;
    }
}


$recommendFoods = array();
$len = 0;
/*
for($i = 1 ; $i <= 5 ; $i++ ){
    if( $count[$i][0] >= 2){
        for($j = 1 ; $j < $count[$i][0]  ; $j++){
            maximun( $bmi , $count[$i][$j],$count[$i][$j+1],$count,$i,$j) ;
            $sql = "SELECT * FROM food where id = '$count[$i][$count[$i][0]]'" ;
            $results=mysqli_query($con, $sql);
            $recommendFoods[]=mysqli_fetch_array($results, MYSQLI_ASSOC) ;
        }
    }else{
        $sql = "SELECT * FROM food where category = '$i'" ;
        $results=mysqli_query($con, $sql);
        $recommendFoods[]=mysqli_fetch_array($results, MYSQLI_ASSOC) ;
    }
}
*/
for($i = 1 ; $i <= 4 ; $i++ ){
    $con = new mysqli("us-cdbr-iron-east-04.cleardb.net","b18b3763eadec5","9e99bd89","ad_7cd90a243a69c36");
    if (mysqli_connect_errno()) {
        $a = array();
        $a["success"] = 0;
        $arr = json_encode($a);
        echo $arr;
        die(mysqli_connect_error());
    }

    $sql = "SELECT * FROM food" ;
    $result=mysqli_query($con, $sql);
    $recommendFoods[]=mysqli_fetch_array($results, MYSQLI_ASSOC) ;

}

$dictionary = array();

$dictionary['success'] = 1;
$dictionary['data'] = $recommendFoods;
$returnJson = json_encode($dictionary);

/*
echo $returnJson;
function maxs ($i ,$s,$array,$num,$z){
    $sss  = $array[$num][$z] ;

    if ($i-$s >=0 ){
        $array[$num][$z] = $array[$num][$z+1] ;
        $array[$num][$z+1] = $sss ;

    }
}
function maximum ($i,$x,$y,$array,$num,$col){
    $con = new mysqli("us-cdbr-iron-east-04.cleardb.net","b18b3763eadec5","9e99bd89","ad_7cd90a243a69c36");
    if (mysqli_connect_errno()) {
        $a = array();
        $a["success"] = 0;
        $arr = json_encode($a);
        echo $arr;
        die(mysqli_connect_error());
    }
    $sql = "SELECT * FROM food where id = $x" ;
    $sq =  "SELECT * FROM food where id = $y" ;
    $results=mysqli_query($con, $sql);
    $resultss=mysqli_query($con, $sq);
    $rows=mysqli_fetch_array($results, MYSQLI_ASSOC) ;
    $rowss=mysqli_fetch_array($resultss, MYSQLI_ASSOC) ;



    if($i == 0){

            maxs(0.5*$rows[6]+0.5*$rows[7] , 0.5*$rowss[6]+0.5*$rowss[7],$array,$num,$col) ;


    }else if($i == 1 ){

            maxs(5 * $rows[5] + 0.3 * $rows[6] + 0.7 * $rows[7], 5 * $rowss[5] + 0.3 * $rowss[6] + 0.7 * $rowss[7], $array, $num, $col);

    }else{

            maxs(-5 * $rows[5] + 0.7 * $rows[6] + 0.3 * $rows[7], -5 * $rowss[5] + 0.7*$rowss[6] + 0.7 * $rowss[7], $array, $num, $col);

    }


}



?>