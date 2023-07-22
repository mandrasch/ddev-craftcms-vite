// https://www.npmjs.com/package/vite-plugin-restart
import ViteRestart from 'vite-plugin-restart';

// TODO: import legacy from '@vitejs/plugin-legacy' ? 
// (https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms)

// defaults, local DDEV (with ddev-router)
let port = 5173; 
let origin = `${process.env.DDEV_PRIMARY_URL}:${port}`;

// for debugging:
// console.log(process.env);

// DDEV + codespaces (without ddev-router), switch port to 5174
// (you need to switch the port manually to HTTPS + public on codespaces)
if (Object.prototype.hasOwnProperty.call(process.env, 'CODESPACES')) {
    console.log('Codespaces environment detected:', {
        'CODESPACES' : process.env?.CODESPACES,
        'CODESPACE_NAME' : process.env?.CODESPACE_NAME,
        'GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN': process.env?.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN
    });
    port = 5174;
    origin = `https://${process.env.CODESPACE_NAME}-${port}.${process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`;
}else{
    console.log('Local DDEV detected',{
        port, origin
    })
}


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
    // adjustments for ddev:
    server: {
        // respond to all network requests:
        host: '0.0.0.0',
        port: port,
        strichPort: true, 
        // origin is important, see https://nystudio107.com/docs/vite/#vite-processed-assets
        origin: origin,
    },
    plugins: [
        ViteRestart({
        restart: [
            './templates/**/*',
        ],
    })]
});
