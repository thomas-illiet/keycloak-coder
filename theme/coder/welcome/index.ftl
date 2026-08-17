<#macro formField id name label type="text" autocomplete="" required=false>
  <div class="welcome-field">
    <label for="${id}">
      ${label}<#if required><span class="welcome-required" aria-hidden="true">*</span></#if>
    </label>
    <span class="welcome-control">
      <input
        id="${id}"
        name="${name}"
        type="${type}"
        <#if autocomplete?has_content>autocomplete="${autocomplete}"</#if>
        <#if required>required aria-required="true"</#if>
      >
    </span>
  </div>
</#macro>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
    <meta name="theme-color" content="#090b0b">
    <title>Welcome to Code Station</title>
    <link rel="icon" type="image/svg+xml" href="${resourcesPath}/img/favicon.svg">
    <link rel="stylesheet" href="${resourcesPath}/css/welcome.css">
  </head>
  <body>
    <div class="welcome-shell">
      <header class="welcome-header">
        <a class="welcome-brand" href="${baseUrl}" aria-label="Code Station home">code station</a>
        <div class="welcome-status" role="status">
          <span class="welcome-status-dot" aria-hidden="true"></span>
          <span>IDENTITY ONLINE</span>
        </div>
      </header>

      <main class="welcome-layout">
        <section class="welcome-hero" aria-labelledby="welcome-title">
          <p class="welcome-eyebrow">DEVELOPER IDENTITY LAYER</p>
          <h1 id="welcome-title">YOUR CODE.<br>YOUR CLOUD.<br>YOUR STATION.</h1>
          <p class="welcome-lede">A secure front door for developer workspaces, administration, and account access.</p>

          <div class="welcome-terminal" aria-label="Code Station status">
            <div class="welcome-terminal-header">
              <span class="welcome-terminal-dots" aria-hidden="true"><i></i><i></i><i></i></span>
              <span>identity/status</span>
            </div>
            <div class="welcome-terminal-body">
              <p><span>$</span> codestation status</p>
              <p><strong>✓</strong> keycloak connected</p>
              <p><strong>→</strong> realm coder ready</p>
            </div>
          </div>
        </section>

        <section class="welcome-card" aria-labelledby="welcome-card-title">
          <#if successMessage?has_content>
            <div class="welcome-icon welcome-icon-success" aria-hidden="true">✓</div>
            <p class="welcome-card-kicker">SETUP COMPLETE</p>
            <h2 id="welcome-card-title">Administration is ready.</h2>
            <div class="welcome-alert welcome-alert-success" role="status">${successMessage}</div>
            <#if adminConsoleEnabled>
              <a class="welcome-button welcome-button-primary" href="${adminUrl}">
                Open administration <span aria-hidden="true">→</span>
              </a>
            </#if>
          <#elseif adminConsoleEnabled && bootstrap>
            <#if localUser>
              <p class="welcome-card-kicker">FIRST RUN</p>
              <h2 id="welcome-card-title">Create your administrator.</h2>
              <p class="welcome-card-copy">Set up the first local account used to manage Code Station identity.</p>

              <#if errorMessage?has_content>
                <div class="welcome-alert welcome-alert-error" role="alert">${errorMessage}</div>
              </#if>

              <form class="welcome-form" method="post" novalidate>
                <@formField id="username" name="username" label="Username" autocomplete="username" required=true />
                <@formField id="password" name="password" label="Password" type="password" autocomplete="new-password" required=true />
                <@formField id="password-confirmation" name="passwordConfirmation" label="Confirm password" type="password" autocomplete="new-password" required=true />
                <@formField id="email" name="email" label="Email" type="email" autocomplete="email" />
                <@formField id="firstName" name="firstName" label="First name" autocomplete="given-name" />
                <@formField id="lastName" name="lastName" label="Last name" autocomplete="family-name" />
                <input name="stateChecker" type="hidden" value="${stateChecker}">
                <button class="welcome-button welcome-button-primary" type="submit">
                  Create administrator <span aria-hidden="true">→</span>
                </button>
              </form>
            <#else>
              <div class="welcome-icon" aria-hidden="true">_</div>
              <p class="welcome-card-kicker">SECURE SETUP</p>
              <h2 id="welcome-card-title">Local access required.</h2>
              <p class="welcome-card-copy">Create the first administrator from localhost or with the Keycloak bootstrap command.</p>
              <code class="welcome-command">bin/kc.sh bootstrap-admin user</code>
            </#if>
          <#else>
            <div class="welcome-icon" aria-hidden="true">&gt;_</div>
            <p class="welcome-card-kicker">WELCOME</p>
            <h2 id="welcome-card-title">Code Station is ready.</h2>
            <p class="welcome-card-copy">Choose where you want to continue. Identity services are online and the coder realm is available.</p>

            <div class="welcome-actions">
              <#if adminConsoleEnabled>
                <a class="welcome-button welcome-button-primary" href="${adminUrl}">
                  Open administration <span aria-hidden="true">→</span>
                </a>
              </#if>
              <a class="welcome-button welcome-button-secondary" href="${baseUrl}realms/coder/account">
                Open account console <span aria-hidden="true">↗</span>
              </a>
            </div>

            <dl class="welcome-meta">
              <div><dt>REALM</dt><dd>coder</dd></div>
              <div><dt>PROTOCOL</dt><dd>OIDC</dd></div>
              <div><dt>STATUS</dt><dd class="is-ready">ready</dd></div>
            </dl>
          </#if>
        </section>
      </main>

      <footer class="welcome-footer">
        <span>SECURED BY INNOVATION</span>
        <span>CODE STATION / IDENTITY</span>
      </footer>
    </div>
  </body>
</html>
