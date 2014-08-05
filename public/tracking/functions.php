<?php

function sessionMaintain($user) {
    session_start();
    if ($user != '') {
        if ($user == 'logout') {
            $name = $_SESSION['user'];
            $string = '<div>user:<span class="name">' . $_SESSION['user'] . '</span> has left the chat</div>';
            $filehandle = fopen('room1.txt', 'a+');
            fwrite($filehandle, $string);
            session_destroy();
            header('Location:balloontracker3copy.html');
            fclose($filehandle);
            return;
        }
        if (!isset($_SESSION['user'])) {
            $_SESSION['user'] = $user;
            $filehandle = fopen('room1.txt', 'a+');
            $string = '<div>user:<span class="name">' . $_SESSION['user'] . '</span> joined the chat</div>';
            fwrite($filehandle, $string);
            fclose($filehandle);
            return;
        }
    }
}

?>
