<?php

use craft\helpers\App;
// https://nystudio107.com/docs/vite/#using-ddev
return [
	'checkDevServer' => true,
	'devServerInternal' => 'http://localhost:3000',
	'devServerPublic' => App::env('PRIMARY_SITE_URL') . ':3000',
	'serverPublic' => App::env('PRIMARY_SITE_URL') . '/dist/',
	'useDevServer' => App::env('ENVIRONMENT') === 'dev' || App::env('CRAFT_ENVIRONMENT') === 'dev',
	// other config settings...
];