<?php

use craft\helpers\App;
// https://nystudio107.com/docs/vite/#using-ddev

// https://github.com/orgs/community/discussions/5104
// https://docs.github.com/en/codespaces/developing-in-codespaces/default-environment-variables-for-your-codespace
$devServerPublic = App::env('PRIMARY_SITE_URL') . ':5173'; // default, local DDEV
if (getenv('CODESPACES') !== false) {
	// for codespaces
	$devServerPublic = 'https://' . getenv('CODESPACE_NAME') . '-5173.' . getenv('GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN');
}

return [
	'checkDevServer' => true,
	'devServerInternal' => 'http://localhost:5173',
	'devServerPublic' => $devServerPublic,
	'serverPublic' => App::env('PRIMARY_SITE_URL') . '/dist/',
	'useDevServer' => App::env('ENVIRONMENT') === 'dev' || App::env('CRAFT_ENVIRONMENT') === 'dev',
	// other config settings...
];
