<?php

use craft\helpers\App;
// https://nystudio107.com/docs/vite/#using-ddev

// Adjustments for DDEV (local), DDEV within Gitpod or DDEV within Codespaces
// (if you want to detect if DDEV is generally used, check App::env('IS_DDEV_PROJECT'))

// Local DDEV project
if (!App::env('GITPOD_WORSPACE_URL') || App::env('CODESPACES')) {

	return [
		// this will ping $devServerInternal to make sure it's running, 
		// otherwise it falls back to web/dist/manifest.json
		'checkDevServer' => true,
		'devServerInternal' => 'http://localhost:5173',
		'devServerPublic' => preg_replace('/:\d+$/', '', App::env('PRIMARY_SITE_URL')) . ':5173',
		'useDevServer' => App::env('ENVIRONMENT') === 'dev' || App::env('CRAFT_ENVIRONMENT') === 'dev',
		// the common suggestion is 'serverPublic' => App::env('PRIMARY_SITE_URL') . '/dist/', 
		// but that can lead to CORS errors on craft sites with multiple domains. So we use this:
		'serverPublic' => '/dist/',
		// for vite v4
		// 'manifestPath' => '@webroot/dist/manifest.json',
		// for vite >= v5
		'manifestPath' => '@webroot/dist/.vite/manifest.json'
	];
}


// Gitpod support
if (App::env('GITPOD_WORKSPACE_URL') !== null) {
	$port = 5173;
	$devServerPublic = App::env('PRIMARY_SITE_URL') . ':' . $port;
	$gitpodWorkspaceUrl = App::env('GITPOD_WORKSPACE_URL');
	$devServerPublic = str_replace("https://", "https://5173-", $gitpodWorkspaceUrl);

	return [
		// this will ping $devServerInternal to make sure it's running, 
		// otherwise it falls back to web/dist/manifest.json
		'checkDevServer' => true,

		'devServerInternal' => 'http://localhost:' . $port,
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
}

// Codespaces support
if (App::env('CODESPACES') === true) {
	$port = 5173;
	$devServerPublic = App::env('PRIMARY_SITE_URL') . ':' . $port;
	$devServerPublic = "https://" . App::env('CODESPACE_NAME') . "-" . $port . "." . App::env('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');

	return [
		// this will ping $devServerInternal to make sure it's running, 
		// otherwise it falls back to web/dist/manifest.json
		'checkDevServer' => true,

		'devServerInternal' => 'http://localhost:' . $port,
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
}
