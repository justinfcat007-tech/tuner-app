<template>
  <div class="support-page">
    <header class="page-header">
      <button class="back-btn" @click="$router.back()" aria-label="Go back">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M15 18l-6-6 6-6"/>
        </svg>
      </button>
      <h1 class="page-title">Support</h1>
    </header>

    <div class="page-content">
      <section class="section">
        <h2>Microphone not working?</h2>
        <ul>
          <li>Make sure you granted microphone permission when prompted.</li>
          <li>If you denied permission, go to your browser or device settings and allow microphone access for this site.</li>
          <li>Close other apps that may be using the microphone.</li>
          <li>Try refreshing the page and tapping <strong>Start</strong> again.</li>
        </ul>
      </section>

      <section class="section">
        <h2>Tuning unstable or jumping?</h2>
        <ul>
          <li>Play one string at a time in a quiet environment.</li>
          <li>Keep the microphone close to the sound hole or strings.</li>
          <li>Wait a moment for the pitch to stabilize before adjusting.</li>
        </ul>
      </section>

      <section class="section">
        <h2>Offline usage</h2>
        <p>
          Tuner works entirely offline after the first load.
          No internet connection is required for tuning.
        </p>
      </section>

      <section class="section">
        <h2>Send feedback</h2>
        <p>
          Have a suggestion or found a bug?
          <a href="mailto:support@tunerapp.example" class="contact-link">Email us</a>
        </p>
      </section>

      <section class="section">
        <h2>Privacy</h2>
        <p>
          Read our <router-link to="/privacy" class="footer-link">Privacy Policy</router-link>.
        </p>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
// no dynamic data needed
</script>

<style scoped>
.support-page {
  background: var(--color-canvas, #10151D);
  min-height: 100vh;
  color: var(--color-text-primary, #F8FAFC);
  max-width: 480px;
  margin: 0 auto;
}
.page-header {
  display: flex; align-items: center; gap: 16px; padding: 16px;
}
.back-btn {
  width: 44px; height: 44px;
  background: none; border: none;
  color: var(--color-text-primary, #F8FAFC);
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  border-radius: 50%;
  transition: background var(--motion-fast, 150ms);
}
.back-btn:hover { background: rgba(255,255,255,0.08); }
.page-title {
  font-family: var(--font-display, Georgia);
  font-size: var(--size-title, 24px);
  font-weight: 700;
  margin: 0;
}
.page-content { padding: 0 16px 48px; }
.section { margin-bottom: 24px; }
.section h2 {
  font-size: var(--size-body-large, 17px);
  font-weight: 600;
  margin: 0 0 8px;
  color: var(--color-text-primary, #F8FAFC);
}
.section p {
  font-size: var(--size-body, 15px);
  color: var(--color-text-secondary, #B8C2CC);
  line-height: var(--lh-normal, 1.45);
  margin: 0;
}
.section ul {
  margin: 0;
  padding-left: 20px;
  color: var(--color-text-secondary, #B8C2CC);
  font-size: var(--size-body, 15px);
  line-height: var(--lh-normal, 1.45);
}
.section li { margin-bottom: 6px; }
.section li strong { color: var(--color-text-primary, #F8FAFC); }
.contact-link, .footer-link {
  color: var(--color-accent, #E7B65C);
  text-decoration: none;
}
.contact-link:hover, .footer-link:hover { text-decoration: underline; }
</style>
