// https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms
// https://www.npmjs.com/package/vite-plugin-restart
import ViteRestart from 'vite-plugin-restart';
// TODO: import legacy from '@vitejs/plugin-legacy' ? (https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms)

// https://github.com/vitejs/vite/pull/677#issuecomment-1473740472
const codespaceName = process.env['CODESPACE_NAME'];
const codespaceDomain = process.env['GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN'];
const hmrPort = 5173;

const hmrRemoteHost = codespaceName ? `${codespaceName}-${hmrPort}.${codespaceDomain}` : 'localhost';
const hmrRemotePort = codespaceName ? 443 : hmrPort;
const hmrRemoteProtocol = codespaceName ? 'wss' : 'ws';

console.log({codespaceName, codespaceDomain, hmrRemoteHost, hmrRemotePort, hmrRemoteProtocol});

// Last step is to set 5173 to PUBLIC in the codespace, else you will get a CORS error. 
// Unfortunately you cannot specify this in the .devcontainer

export default ({ command }) => ({
    // 'vite' is always command = 'serve', other command is 'build'
    base: command === 'serve' ? '' : '/dist/',
    build: {
        manifest: true,
        outDir: '../cms/web/dist/',
        rollupOptions: {
            input: {
                app: './src/js/app.js',
            }
        },
    },
    // for ddev:
    server: {
        host: '0.0.0.0', // react to all incoming traffic
        port: 5173,
        // new - for codespaces:
        // TODO: check if this works locally in DDEV as well...
        hmr: {
            protocol: hmrRemoteProtocol,
            host: hmrRemoteHost,
            port: hmrPort,
            clientPort: hmrRemotePort
        }
    },
    plugins: [
        ViteRestart({
        restart: [
            './templates/**/*',
        ],
    })]
});