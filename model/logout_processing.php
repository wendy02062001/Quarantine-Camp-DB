<?php
    require_once(dirname(__FILE__) . "/../settings.php");
    session_start();

    
    session_unset();
    session_destroy();


    header("Location: ".$ABS_ROOT_PATH."/index.php?page=home");
    exit;
?>