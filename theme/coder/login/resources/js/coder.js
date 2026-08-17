const icon = document.querySelector('link[rel="icon"]');
const script = document.currentScript;

if (icon && script) {
  icon.type = "image/svg+xml";
  icon.href = new URL("../img/favicon.svg", script.src).href;
}

const mountCodeStationLayout = () => {
  const login = document.querySelector(".pf-v5-c-login");
  const container = login?.querySelector(".pf-v5-c-login__container");
  const main = container?.querySelector(".pf-v5-c-login__main");
  const brand = container?.querySelector("#kc-header") || login?.querySelector("#kc-header");

  if (!login || !container || !main || !brand) {
    return;
  }

  let layoutHeader = login.querySelector(".code-station-login-header");

  if (!layoutHeader) {
    layoutHeader = document.createElement("div");
    layoutHeader.className = "code-station-login-header";
    login.insertBefore(layoutHeader, container);
  }

  if (brand.parentElement !== layoutHeader) {
    layoutHeader.append(brand);
  }

  if (!layoutHeader.querySelector(".code-station-status")) {
    const status = document.createElement("div");

    status.className = "code-station-status";
    status.setAttribute("role", "status");
    status.innerHTML = `
      <span class="code-station-status-dot" aria-hidden="true"></span>
      <span>IDENTITY ONLINE</span>
    `;
    layoutHeader.append(status);
  }

  if (!container.querySelector(".code-station-login-hero")) {
    const hero = document.createElement("section");

    hero.className = "code-station-login-hero";
    hero.setAttribute("aria-label", "Code Station developer identity");
    hero.innerHTML = `
      <p class="code-station-eyebrow">DEVELOPER IDENTITY LAYER</p>
      <p class="code-station-display">YOUR CODE.<br>YOUR CLOUD.<br>YOUR STATION.</p>
      <p class="code-station-lede">A secure front door for developer workspaces, administration, and account access.</p>

      <div class="code-station-terminal" aria-label="Code Station status">
        <div class="code-station-terminal-header">
          <span class="code-station-terminal-dots" aria-hidden="true"><i></i><i></i><i></i></span>
          <span>identity/status</span>
        </div>
        <div class="code-station-terminal-body">
          <p><span>$</span> codestation status</p>
          <p><strong>✓</strong> keycloak connected</p>
          <p><strong>→</strong> realm bnp-paribas ready</p>
        </div>
      </div>
    `;
    container.insertBefore(hero, main);
  }

  const mainHeader = main.querySelector(".pf-v5-c-login__main-header");

  if (mainHeader && !mainHeader.querySelector(".code-station-card-header")) {
    const cardHeader = document.createElement("div");

    cardHeader.className = "code-station-card-header";
    cardHeader.innerHTML = `
      <div class="code-station-card-icon" aria-hidden="true">&gt;_</div>
      <div class="code-station-card-heading-copy">
        <p class="code-station-card-kicker">SIGN IN</p>
        <p class="code-station-card-context">IDENTITY GATEWAY</p>
      </div>
    `;
    mainHeader.prepend(cardHeader);
  }

  if (!login.querySelector(".code-station-footer")) {
    const footer = document.createElement("footer");
    const security = document.createElement("span");
    const identity = document.createElement("span");

    footer.className = "code-station-footer";
    footer.setAttribute("aria-label", "Code Station identity footer");
    security.textContent = "SECURED BY INNOVATION";
    identity.textContent = "CODE STATION / IDENTITY";
    footer.append(security, identity);
    login.append(footer);
  }

  login.classList.add("code-station-layout-ready");
};

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", mountCodeStationLayout, { once: true });
} else {
  mountCodeStationLayout();
}
