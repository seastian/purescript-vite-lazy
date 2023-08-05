import { defineConfig } from "vite";
import Inspect from "vite-plugin-inspect";

const r = /\((DynamicImport\.dynamicImport\(([A-Z]\w*)\.([a-z_]\w*)\))\)/;

export default defineConfig({
  plugins: [
    Inspect(),
    {
      name: "dynamic-imports",
      transform(src, _) {
        const t = src.replace(r, (match, g, moduleName, componentName) => {
          return `(() => import("../${moduleName}/index.js").then(r => r["${componentName}"]))`;
        });
        return { code: t };
      },
    },
  ],
});
