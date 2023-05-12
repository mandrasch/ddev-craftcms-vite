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
        host: '0.0.0.0',
        port: 3000
    },
    plugins: [
        ViteRestart({
        restart: [
            './templates/**/*',
        ],
    })]
});