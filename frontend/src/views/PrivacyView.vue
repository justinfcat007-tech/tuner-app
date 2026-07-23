<template>
  <div class="privacy-page">
    <header class="page-header">
      <button class="back-btn" @click="$router.back()" aria-label="Go back">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M15 18l-6-6 6-6"/>
        </svg>
      </button>
      <h1 class="page-title">Privacy Policy</h1>
    </header>

    <div class="page-content">
      <section class="section">
        <h2>Microphone Usage</h2>
        <p>
          Tuner uses your device's microphone solely for real-time pitch detection.
          Audio is processed locally on your device and is <strong>never uploaded, recorded, cached, or analyzed</strong> by our servers.
        </p>
      </section>

      <section class="section">
        <h2>No Account Required</h2>
        <p>
          This app does not require you to create an account, log in, or provide personal information
          to use the core tuning features.
        </p>
      </section>

      <section class="section">
        <h2>No Ads or Analytics</h2>
        <p>
          The MVP version does not include advertising SDKs, third-party analytics,
          or behavioral tracking. We do not collect data for advertising purposes.
        </p>
      </section>

      <section class="section">
        <h2>Local Data Storage</h2>
        <p>
          Your preferences (last instrument, A4 reference frequency, voice feedback settings)
          are stored locally on your device using browser local storage.
          You can delete this data at any time by clearing your app data or browser storage.
        </p>
      </section>

      <section class="section">
        <h2>Installation Cohort</h2>
        <p>
          On first launch, the app creates an anonymous installation record containing a random ID
          and timestamp. This record stays on your device and is not uploaded. It is reserved for
          future migration purposes (e.g., recognizing early-access users) and does not contain
          account, hardware, or audio information.
        </p>
      </section>

      <section class="section">
        <h2>Contact</h2>
        <p>
          For privacy questions, please contact:
          <a href="mailto:support@tunerapp.example" class="contact-link">support@tunerapp.example</a>
        </p>
      </section>

      <div class="meta-info">
        <p>Version: {{ appVersion }}</p>
        <p>Last updated: {{ lastUpdated }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const appVersion = (import.meta.env.VITE_APP_VERSION as string) || '1.0.0'
const lastUpdated = '2026-07-23'
</script>

<style scoped>
.privacy-page {
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
.section p strong { color: var(--color-text-primary, #F8FAFC); }
.contact-link {
  color: var(--color-accent, #E7B65C);
  text-decoration: none;
}
.contact-link:hover { text-decoration: underline; }
.meta-info {
  margin-top: 32px;
  padding-top: 16px;
  border-top: 1px solid var(--color-border, #314050);
}
.meta-info p {
  font-size: var(--size-caption, 12px);
  color: var(--color-text-muted, #7F8A96);
  margin: 4px 0;
}
</style>
