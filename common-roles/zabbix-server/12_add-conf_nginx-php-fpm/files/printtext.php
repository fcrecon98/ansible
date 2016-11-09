<?php
$bgcolor = $_GET["bgcolor"];
$textcolor = $_GET["textcolor"];
$width = $_GET["width"];
$height = $_GET["height"]
?>
<body style="display:table-cell;text-align:center;vertical-align:middle;background:#<?php print $bgcolor; ?>;color:#<?php print $textcolor; ?>;width: <?php print $width; ?>;height: <?php print $height; ?>;">
<b>
<?php
  echo $_GET["text"];
?>
</b>
</body>
