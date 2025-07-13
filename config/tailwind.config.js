module.exports = {
  safelist: [
    {
      pattern: /prose/,
    },
  ],
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/assets/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
};
