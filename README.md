# ddev-craftcms-vite 

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/mandrasch/ddev-craftcms-vite/)

Simple demo for [CraftCMS v5](https://craftcms.com/) + [DDEV](https://ddev.com/), including support for [nystudio107/craft-vite](https://github.com/nystudio107/craft-vite). Have fun with it!

You can run this 

1. on [your local laptop](#1-local-setup)
1. via [Gitpod in your browser](#2-gitpod)
1. via [Codespaces (experimental)](#3-codespaces-experimental)

See [How was this created?](#how-was-this-created) for more information.

## 1. Local setup

Install [DDEV](https://ddev.com/get-started/) and run the following commands:

```bash
git clone https://github.com/mandrasch/ddev-craftcms-vite.git
# or git clone git@github.com:mandrasch/ddev-craftcms-vite.git

cd ddev-craftcms-vite/

# automatically creates .env with correct db settings
ddev start 

# install dependencies
ddev composer install && ddev npm install

# install craft cms
# You can remove password from this command if you want to enter it manually
ddev craft install/craft \
  --username="admin" \
  --email="admin@example.com" \
  --password="password123" \
  --site-name="Testsite" \
  --language="en" \
  --site-url='$DDEV_PRIMARY_URL'

# already installed in composer, but needs activation:
ddev craft plugin/install vite

# Open your website in browser, ...
ddev launch

# start the local dev server (Vite), ...
ddev npm run dev

# ... and hit reload in browser. Vite should work now 🥳
```

After first time setup, only `ddev npm run dev` is needed (after `ddev start`). 

Your site is accessible via https://ddev-laravel-vite.ddev.site.

You could also import a database dump via `ddev import-db --file=dump.sql.gz` or use [`ddev pull`](https://ddev.readthedocs.io/en/stable/users/providers/) to setup a project. Use `ddev sequelace` to view your database.

## 2. Gitpod

Just hit the button, wait for the initial setup and start developing:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/mandrasch/ddev-craftcms-vite/)

## 3. Codespaces (experimental)

⚠️ Disclaimer - May 2024: Codespaces is currently a bit buggy on startups, see https://github.com/devcontainers/features/issues/977.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/mandrasch/ddev-craftcms-vite)

1. Click the button
1. Wait for `postCreateCommand.sh` to be finished
1. Switch Vite port to public in ports tab
1. Run `ddev npm run dev`
1. Open site (web http) via ports tab (or use `ddev launch` in future (currently small bug to be fixed)).

See all steps in this video and blog post:

- https://www.youtube.com/watch?v=ruw24tJHB5s
- https://dev.to/mandrasch/open-craftcms-in-github-codespaces-via-ddev-21he

The port switch can take a minute. Just wait if it doesn't work instantly.

Access control panel via `/admin` (or use in future `ddev launch /admin`, when small bug is fixed in ddev).

Login via user `admin` and password `newPassword` .

### Troubleshooting

See creation log via 'CMD + P > View creation log' if errors occur. Unfortunately there is no general error notification when this fails. But if there is only one port in the ports tab installation did not succeed. Sometimes only a full rebuild solve the problems, use:

- `SHIFT + CMD + P > Codespaces: Full rebuild` 

Containers and db will be deleted.

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
    {{ craft.vite.script("src/js/app.js", false) }} 
```

7. That's it, have fun!

8. Updated from v4 to v5 https://craftcms.com/docs/5.x/upgrade.html

## Reset the demo

```bash
# delete without snapshot
ddev delete -O
# reset files, beware: deletes all untracked files!
git clean -fdx
# reset files, but not .ddev
git clean -fdx -e .ddev/
```

## Acknowledgements

Thanks to the DDEV maintainers and DDEV open source community, especially [Randy Fay](https://github.com/rfay) for suggestions and feedback! 💚

Huge thanks to ...

- [nystudio107](https://nystudio107.com/) for providing the open source Vite plugin for Craft CMS.
- [@superflausch](https://github.com/superflausch) for a quick chat about Codespaces + Vite + craft integration.
- [dotsandlines](https://craftcms.com/partners/dotsandlines) for the opportunity to learn more about codespaces usage.
- [Ofer Shaal](https://github.com/shaal) for providing DrupalPod (base for Gitpod support)

## Further resources

- Official plugin site: https://plugins.craftcms.com/vite

More experiments and notes about DDEV + vite: https://my-ddev-lab.mandrasch.eu/

Connect with the DDEV community on [Discord](https://discord.gg/hCZFfAMc5k)
