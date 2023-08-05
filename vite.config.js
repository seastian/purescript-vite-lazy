import { defineConfig } from "vite";
import Inspect from "vite-plugin-inspect";

const r = /\((DynamicImport\.dynamicImport\(([A-Z]\w*)\.([a-z_]\w*)\))\)/g;

export default defineConfig({
  plugins: [
    Inspect(),
    {
      name: "dynamic-imports",
      transform(src, _) {
        let moduleImportsToRemove = ["DynamicImport"];
        const withDynamicImports = src.replaceAll(
          r,
          (match, g, moduleName, componentName) => {
            moduleImportsToRemove.push(moduleName);
            return `(() => import("../${moduleName.replace( "_", ".")}/index.js").then(r => r["${componentName}"]))`;
          }
        );
        const withStaticImportsRemoved = moduleImportsToRemove.reduce(
          (transformed, moduleName) => transformed.replaceAll(new RegExp(`import \\* as ${moduleName} from (.*?);`,"g"), ""),
          withDynamicImports
        );
        return { code: withStaticImportsRemoved };
      },
    },
  ],
});
