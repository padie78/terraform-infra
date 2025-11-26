<?php
// Función para obtener metadata de la instancia
function get_instance_metadata($path) {
    $url = "http://169.254.169.254/latest/meta-data/" . $path;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $result = curl_exec($ch);
    curl_close($ch);
    return $result;
}

// Obtenemos algunos datos importantes
$instance_id = get_instance_metadata("instance-id");
$private_ip  = get_instance_metadata("local-ipv4");
$public_ip   = get_instance_metadata("public-ipv4");
$availability_zone = get_instance_metadata("placement/availability-zone");
$instance_type = get_instance_metadata("instance-type");

echo "<h1>Información de esta instancia EC2</h1>";
echo "<ul>";
echo "<li>Instance ID: $instance_id</li>";
echo "<li>IP privada: $private_ip</li>";
echo "<li>IP pública: $public_ip</li>";
echo "<li>Availability Zone: $availability_zone</li>";
echo "<li>Instance Type: $instance_type</li>";
echo "</ul>";
?>
