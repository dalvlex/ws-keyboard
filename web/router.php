<?php
  // Serve static resources as files
  if (preg_match('/\.(?:js|css|png|jpg|jpeg|gif)$/', $_SERVER["REQUEST_URI"])) {
      return false;
  }
  // Serve AJAX requests from web-ajax.php
  elseif(isset($_REQUEST['request'])){
  	require('request.php');
  }
  // Serve HTML UI
  else {
    require('ui.html');
  }

