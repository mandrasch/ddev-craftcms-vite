// https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms
// https://www.npmjs.com/package/vite-plugin-restart
import ViteRestart from 'vite-plugin-restart';
// TODO: import legacy from '@vitejs/plugin-legacy' ? (https://nystudio107.com/blog/using-vite-js-next-generation-frontend-tooling-with-craft-cms)

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
        // respond to all network requests:
        host: '0.0.0.0',
        port: 5173,
        // origin is important, see https://nystudio107.com/docs/vite/#vite-processed-assets
        origin: `${process.env.DDEV_PRIMARY_URL}:5173`
    },
    plugins: [
        ViteRestart({
        restart: [
            './templates/**/*',
        ],
    })]
});
