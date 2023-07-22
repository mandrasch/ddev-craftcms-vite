<?php

use craft\helpers\App;
// https://nystudio107.com/docs/vite/#using-ddev

// Adjustments for DDEV (local) or DDEV + codespaces
// (if you want to detect if DDEV is used, you can check App::env('IS_DDEV_PROJECT'))

// default, local DDEV (via ddev-router)
$devServerPublic = App::env('PRIMARY_SITE_URL') . ':5173';

// DDEV + codespaces (without ddev-router), switch to port 5174
if (App::env('CODESPACES') === true) {
		$devServerPublic = "https://" . App::env('CODESPACE_NAME') . "-5174." . App::env('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
}

return [
	'checkDevServer' => true,
	'devServerInternal' => 'http://localhost:5173',
	'devServerPublic' => $devServerPublic,
	'serverPublic' => App::env('PRIMARY_SITE_URL') . '/dist/',
	'useDevServer' => App::env('ENVIRONMENT') === 'dev' || App::env('CRAFT_ENVIRONMENT') === 'dev',
	// other config settings...
];
