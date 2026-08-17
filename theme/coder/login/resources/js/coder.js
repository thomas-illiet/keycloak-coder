const icon = document.querySelector('link[rel="icon"]');
const script = document.currentScript;

if (icon && script) {
  icon.type = "image/svg+xml";
  icon.href = new URL("../img/favicon.svg", script.src).href;
}
