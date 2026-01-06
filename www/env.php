<?php

echo json_encode([
    'uname' => php_uname('a'),
    '$_SERVER' => $_SERVER,
    '$_ENV' => $_SERVER,
    '$_GET' => $_GET,
    '$_POST' => $_POST,
]);