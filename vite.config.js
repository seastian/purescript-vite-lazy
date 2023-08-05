import { defineConfig } from "vite";
import Inspect from "vite-plugin-inspect";

const r = /\((DynamicImport\.dynamicImport\(([A-Z]\w*)\.([a-z_]\w*)\))\)/g;

export default defineConfig({
  plugins: [
    Inspect(),
    {
      name: "dynamic-imports",
      transform(src, currentFile) {
        let moduleImportsToRemove = ["DynamicImport"];
        const withDynamicImports = src.replaceAll(
          r,
          (match, g, moduleName, componentName) => {
            moduleImportsToRemove.push(moduleName);
            const modulePath = `../${moduleName.replace( "_", ".")}/index.js`
            return `(() => import("${modulePath}").then(r => r["${componentName}"]))`;
          }
        );
        const withStaticImportsRemoved = moduleImportsToRemove.reduce(
          (transformed, moduleName) => transformed.replaceAll(new RegExp(`import \\* as ${moduleName} from (.*?);`,"g"), ""),
          withDynamicImports
        );
        const checkIfModulesAreIsolated =
           // This part matches modules that are being accessed with '.'
           // Say your module name in JS is My_Module. This checks that `My_Module.` never occures
           // `My_Module.myFn` is not allowed in lazy loading to have properly isolated modules
           moduleImportsToRemove.flatMap(moduleName => withStaticImportsRemoved.includes(`${moduleName}.`) ? [moduleName] : [])
        
        checkIfModulesAreIsolated.map(moduleName => this.error(`${currentFile} contains references to ${moduleName}.`))

        return { code: withStaticImportsRemoved };
      },
    },
  ],
});
