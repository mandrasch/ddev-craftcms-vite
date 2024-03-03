<?php

use craft\helpers\App;
// https://nystudio107.com/docs/vite/#using-ddev

// Adjustments for DDEV (local) or DDEV + codespaces
// (if you want to detect if DDEV is used, you can check App::env('IS_DDEV_PROJECT'))

// default, local DDEV (via ddev-router)
$port = 5173;
$devServerPublic = App::env('PRIMARY_SITE_URL') . ':' . $port;

// DDEV + codespaces (without ddev-router), switch to port 5174
if (App::env('CODESPACES') === true) {
	$port = 5174;
	$devServerPublic = "https://" . App::env('CODESPACE_NAME') . "-" . $port . "." . App::env('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
}

return [
	// this will ping $devServerInternal to make sure it's running, 
	// otherwise it falls back to web/dist/manifest.json
	'checkDevServer' => true,

	'devServerInternal' => 'http://localhost:'.$port,
	'devServerPublic' => $devServerPublic,
	'useDevServer' => App::env('ENVIRONMENT') === 'dev' || App::env('CRAFT_ENVIRONMENT') === 'dev',

	// the common suggestion is 'serverPublic' => App::env('PRIMARY_SITE_URL') . '/dist/', 
	// but that can lead to CORS errors on craft sites with multiple domains. So we use this:
	'serverPublic' => '/dist/',

	// for vite v4
	// 'manifestPath' => '@webroot/dist/manifest.json',

	// for vite >= v5
	'manifestPath' => '@webroot/dist/.vite/manifest.json'
];