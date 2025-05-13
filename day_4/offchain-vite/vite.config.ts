import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tsconfigPaths from "vite-tsconfig-paths";
import wasm from "vite-plugin-wasm";

// https://vitejs.dev/config/
export default defineConfig({
  build: { target: "es2022" },
  plugins: [react(), tsconfigPaths(), wasm()],
  resolve: {
    alias: { buffer: "buffer" },
  },
  server: {
    proxy: {
      "/koios": {
        rewrite: (path) => path.replace(/^\/koios/, ""),
        target: "https://preview.koios.rest/api/v1",
        changeOrigin: true,
      },
    },
  },
});
