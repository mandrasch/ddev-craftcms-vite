# ddev-craftcms-vite 

Simple demo repository for CraftCMS + DDEV, including support for [nystudio107/craft-vite](https://github.com/nystudio107/craft-vite). Just for demo purposes. Have fun with it!

You can run this on your local laptop (via [docker + DDEV](https://ddev.com/)) or in GitHub Codespaces.

📣 New: Now with Codespaces support! 📣

## Setup in Codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/mandrasch/ddev-craftcms-vite)

1. Click the button
1. Wait for `postCreateCommand.sh` to be finished
1. Switch vite port to public in ports tab
1. Run `npm run dev`
1. Open site (web http) via ports tab (or use `ddev launch` in future (currently small bug to be fixed)).

See all steps in this blog post:

- https://dev.to/mandrasch/open-craftcms-in-github-codespaces-via-ddev-21he

The port switch can take a minute. Just wait if it doesn't work instantly.

Access control panel via `/admin` (or use in future `ddev launch /admin`, when small bug is fixed in ddev).

Login via user `admin` and password `newPassword` .

### Troubleshooting

See creation log via 'CMD + P > View creation log' if errors occur. Unfortunately there is no notification when this fails.

Sometimes only a rebuild or full rebuild solves problems, use

- `SHIFT + CMD + P > Codespaces: Full rebuild` 

Containers and db will be deleted.

Especially `Could not connect to a docker provider. Please start or install a docker provider.` occurs from 1 time out of 5, could not figure out why exactly yet. Please always make sure you're using `"ghcr.io/devcontainers/features/docker-in-docker:2": {},`, not v1.

Also `Your docker install has only 2163760 available disk space, less than 5000000 warning level (94% used). Please increase disk image size. ` errors occur from time to time as well.

### Technical background: workaround for vite port

Since the ddev router is not used on codespaces, the vite setup requires some adjustments. To access vite we expose another port (5174) via `.ddev/docker-compose.codespaces-vite.yaml`. This file is generated on codespace start up (and gitignored). 

We needed to adjust some config values in `config/vite.php` and `vite.config.js` as well when codespaces is used. If codespace is used, the new port 5174 needs to be used (instead of the port 5173 for local DDEV setups).

I implemented this via `.env`. 

See `.devcontainers/postCreateCommand.sh` for all steps.

## Local setup (after clone)

The site will be available here after we're finished:

- https://ddev-craftcms-vite.ddev.site/

These are the steps for a regular local setup (without codespaces):

```bash
cd ddev-craftcms-vite/
ddev start
ddev composer install
ddev craft install
ddev craft plugin/install vite

ddev npm install

# Open your website in browser,
ddev launch
# run local dev server (vite),
ddev npm run dev
# and hit reload in browser
```

## Simulate production environment

1. `ddev npm run build`
2. Switch `CRAFT_ENVIRONMENT=dev` to `CRAFT_ENVIRONMENT=production` in `.env`


## How was this created?

1. Followed the official [DDEV Quickstart for CraftCMS](https://ddev.readthedocs.io/en/latest/users/quickstart/#craft-cms)

```bash
# https://ddev.readthedocs.io/en/latest/users/quickstart/#craft-cms
# Create a project directory and move into it:
mkdir my-craft-project
cd my-craft-project

# Set up the DDEV environment:
ddev config --project-type=craftcms --docroot=web --create-docroot

# Boot the project and install the starter project:
ddev start
ddev composer create -y --no-scripts craftcms/craft

# Run the Craft installer:
ddev craft install
ddev launch
```

2. Installed [nystudio107/craft-vite](https://github.com/nystudio107/craft-vite):

```bash
# install via composer
ddev composer require nystudio107/craft-vite
# activate within craftcms
ddev craft plugin/install vite
```

3. Exposing the ports via [web_extra_exposed_ports](https://ddev.readthedocs.io/en/latest/users/extend/customization-extendibility/#exposing-extra-ports-via-ddev-router):

```yaml
web_extra_exposed_ports:
  - name: craft-vite
    container_port: 5173
    http_port: 5172
    https_port: 5173
```

⚠️ `ddev restart` is needed afterwards

4. Following https://nystudio107.com/docs/vite/#using-ddev and extend the previous config of `vite.config.js`:

```javascript
/* vite.config.js */
    // for ddev:
    server: {
        // respond to all network requests:
        host: '0.0.0.0',
        port: 5173,
        strictPort = true,
        // origin is important, see https://nystudio107.com/docs/vite/#vite-processed-assets
        origin: `${process.env.DDEV_PRIMARY_URL}:5173`
    },
```

5. Install npm deps, as stated here: https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms

```bash
ddev npm init -y
ddev npm install -D vite vite-plugin-restart postcss autoprefixer @vitejs/plugin-legacy sass
```

Add the following scripts to `package.json`:

```json
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
```

- [ ] TODO: Is @vitejs/plugin-legacy always needed? (https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms)

6. Edited `index.twig`, added craft-vite (and created `app.js` + `app.scss` file)

```
    {{ craft.vite.script("src/js/app.js") }} 
```

7. That's it, have fun!

## Further resources

- https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms
- https://github.com/szenario-fordesigners/craft-vite-starter / https://twitter.com/thomasbendl/status/1628741476355112962
- docker, but not ddev: https://github.com/nystudio107/spin-up-craft
- More experiments and info about DDEV + vite: https://my-ddev-lab.mandrasch.eu/
- Thanks to [@superflausch](https://github.com/superflausch) for a quick chat about Codespaces + vite integration

Connect with the DDEV community on [Discord](https://discord.gg/hCZFfAMc5k)

Thanks to the DDEV maintainers and DDEV open source community, especially [Randy Fay](https://github.com/rfay) for suggestions and feedback! 💚