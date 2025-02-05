// https://www.npmjs.com/package/vite-plugin-restart
import ViteRestart from 'vite-plugin-restart';

// defaults, local DDEV
let port = 5173;
let origin = `${process.env.DDEV_PRIMARY_URL}:${port}`;
let primaryUrl = process.env.DDEV_PRIMARY_URL;

// Gitpod support
// env var GITPOD_WORKSPACE_URL needs to be passed through to ddev, see .ddev/config.yaml
if (Object.prototype.hasOwnProperty.call(process.env, 'GITPOD_WORKSPACE_URL')) {
    origin = `${process.env.GITPOD_WORKSPACE_URL}`;
    origin = origin.replace('https://', 'https://5173-');
    // for server.cors
    primaryUrl = `${process.env.GITPOD_WORKSPACE_URL}`;
    primaryUrl = primaryUrl.replace('https://', 'https://8080-');
    console.log(`Gitpod detected, set origin to ${origin}`);
}

// Codespaces support
// env var GITPOD_WORKSPACE_URL needs to be passed through to ddev, see .ddev/config.yaml
// You need to switch the port manually to public on codespaces after launching
if (Object.prototype.hasOwnProperty.call(process.env, 'CODESPACES')) {
    origin = `https://${process.env.CODESPACE_NAME}-${port}.${process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`;
    // for server.cors
    primaryUrl = `https://${process.env.CODESPACE_NAME}-8443.${process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`;
    console.log('Codespaces environment detected, setting config to ', { port, origin });
    console.log("Please check that this can be opened via browser after you run 'ddev npm run dev':");
    console.log(origin + '/src/js/app.js');
    console.log('If it can\'t be opened, please switch the Vite port to public in the ports tab.');
    /* console.log({
        'CODESPACES' : process.env?.CODESPACES,
        'CODESPACE_NAME' : process.env?.CODESPACE_NAME,
        'GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN': process.env?.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN
    });*/
}

export default ({ command }) => ({
    // 'vite' is always command = 'serve', other command is 'build'
    base: command === 'serve' ? '' : '/dist/',
    build: {
        manifest: true,
        outDir: 'web/dist/',
        rollupOptions: {
            input: {
                app: './src/js/app.js',
            }
        },
    },
    // adjustments for ddev:
    server: {
        // Respond to all network requests
        host: '0.0.0.0',
        port: port,
        strictPort: true,
        // Defines the origin of the generated asset URLs during development, this must be set to the
        // Vite dev server URL and selected Vite port. In general, `process.env.DDEV_PRIMARY_URL` will
        // give us the primary URL of the DDEV project, e.g. "https://test-vite.ddev.site". But since
        // DDEV can be configured to use another port (via `router_https_port`), the output can also be
        // "https://test-vite.ddev.site:1234". Therefore we need to strip a port number like ":1234"
        // before adding Vites port to achieve the desired output of "https://test-vite.ddev.site:5173".
        origin: `${process.env.DDEV_PRIMARY_URL.replace(/:\d+$/, "")}:5173`,
        // Configure CORS securely for the Vite dev server to allow requests from *.ddev.site domains,
        // supports additional hostnames (via regex). If you use another `project_tld`, adjust this.
        cors: {
            origin: /https?:\/\/([A-Za-z0-9\-\.]+)?(\.ddev\.site)(?::\d+)?$/,
        },
    },
    plugins: [
        ViteRestart({
            restart: [
                './templates/**/*',
            ],
        })]
});
