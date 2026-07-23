/**
 * MVP mode flag.
 * When true, the app runs as an offline-first guest tuner:
 * no login, no payments, no ads, no analytics SDKs.
 *
 * Set at build time via VITE_MVP_MODE env var.
 * Must NOT be fetched from a server at runtime.
 */
export const isMvpMode: boolean = import.meta.env.VITE_MVP_MODE !== 'false'
