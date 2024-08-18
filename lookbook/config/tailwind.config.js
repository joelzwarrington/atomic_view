const defaultTheme = require("tailwindcss/defaultTheme");
const colors = require("tailwindcss/colors");

const execSync = require("child_process").execSync;
const atomicViewPath =
  execSync("bundle show atomic_view", { encoding: "utf-8" }).trim() +
  "/lib/atomic_view/components/**/*.{erb,rb}";

module.exports = {
  darkMode: "selector",
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
    atomicViewPath,
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          ...colors.cyan,
          DEFAULT: colors.cyan[600],
        },
        secondary: colors.zinc,
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
