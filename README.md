# ddev-craftcms-vite 

Simple demo repository for CraftCMS + DDEV, including support for [nystudio107/craft-vite](https://github.com/nystudio107/craft-vite).

- Status: 🚧 Work in progress 🚧
- Local URL: https://ddev-craftcms-vite.ddev.site/
- **new**: [Open in codespaces](https://codespaces.new/mandrasch/ddev-craftcms-vite/)

## Local setup (after clone)

_These are the steps for a regular local setup (without codespaces)._

```bash
cd ddev-craftcms-vite/
ddev start
ddev composer install
ddev craft install
ddev craft plugin/install vite

ddev npm install

# Open your website, 
ddev launch
# run local dev server (vite),
ddev npm run dev
# and hit reload
```

## Simulate production environment

1. `ddev npm run build`
2. Switch `CRAFT_ENVIRONMENT=dev` to `CRAFT_ENVIRONMENT=production` in `.env`

## Codespaces support

1. [Open in codespaces](https://codespaces.new/mandrasch/ddev-craftcms-vite/)

2. Wait for postCreateCommand to finish

- [ ] TODO: add screenshot here

You can see the status via SHIFT + CMD + P => "Codespaces: View creation log". This can take several minutes (hope we find ways to cache/speed things up in future).


3. Switch the vite port to HTTPS and then to public

- [ ] TODO: add screenshot here

After the project was successfully built on codespaces, you need to switch the vite port 5174 to public + HTTPS (?), otherwise you'll see CORS errors in the javascript devtools console.

The switch can take some time, just wait a minute if it doesn't work instantly.

4. Run `ddev npm run dev` to start vites devserver

5. Open your site in another console via `ddev launch``

6. Access control panel via `ddev launch /admin` and user `admin` - `newPassword`

### Technical background:

Since the ddev router is not used on codespaces, the vite setup requires some adjustments. To access vite we expose another port (5174) via `.ddev/docker-compose.codespaces-vite.yaml`, this file is generated on codespace start up (and gitignored). We need to adjust some config values in `config/vite.php` and `vite.config.js` as well when codespaces is used. I implemented this via `.env`. 

See `.devcontainers/postCreateCommand.sh` for all steps.

### Troubleshooting

Sometimes only a rebuild or full rebuild solves problems, use `SHIFT + CMD + P > Codespaces: Full rebuild`.

Especially `Could not connect to a docker provider. Please start or install a docker provider.` occurs from time to time, could not figure out why exactly yet. Please make sure you're using `"ghcr.io/devcontainers/features/docker-in-docker:2": {},`. 

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
        strichPort = true,
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
- More experiments and info about DDEV + vite: https://my-ddev-lab.mandrasch.eu/


Connect with the DDEV community on [Discord](https://discord.gg/hCZFfAMc5k)

Thanks to the DDEV maintainers and DDEV open source community! 💚