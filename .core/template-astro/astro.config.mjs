import { defineConfig } from 'astro/config';
import tailwindv4 from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: '[SITE_URL]',
  base: '[BASE_PATH]',
  vite: {
    plugins: [tailwindv4()],
  },
});
