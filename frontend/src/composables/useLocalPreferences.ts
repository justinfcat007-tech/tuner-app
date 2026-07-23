import { ref, watch, type Ref } from 'vue'

export type InstrumentType = 'guitar' | 'ukulele' | 'yangqin'
export type A4Reference = 440 | 442 | 443

export interface LocalPreferences {
  lastInstrument: InstrumentType
  a4Reference: A4Reference
  voiceEnabled: boolean
  autoSelectString: boolean
  hasSeenMicEducation: boolean
}

const STORAGE_KEY = 'tuner.preferences.v1'
const INSTALL_KEY = 'tuner.install.v1'

const DEFAULT_PREFERENCES: LocalPreferences = {
  lastInstrument: 'guitar',
  a4Reference: 440,
  voiceEnabled: true,
  autoSelectString: true,
  hasSeenMicEducation: false,
}

export interface InstallCohort {
  installationId: string
  firstInstalledAt: string
  firstSeenVersion: string
  cohort: 'early-access' | 'standard'
}

function generateId(): string {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID()
  }
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0
    const v = c === 'x' ? r : (r & 0x3) | 0x8
    return v.toString(16)
  })
}

function getAppVersion(): string {
  return (import.meta.env.VITE_APP_VERSION as string) || '1.0.0'
}

function getInstallCohort(): InstallCohort {
  try {
    const raw = localStorage.getItem(INSTALL_KEY)
    if (raw) {
      const existing = JSON.parse(raw) as InstallCohort
      if (existing.installationId && existing.firstInstalledAt) {
        return existing
      }
    }
  } catch {
    // fallthrough
  }

  const cohort: InstallCohort = {
    installationId: generateId(),
    firstInstalledAt: new Date().toISOString(),
    firstSeenVersion: getAppVersion(),
    cohort: 'early-access',
  }

  try {
    localStorage.setItem(INSTALL_KEY, JSON.stringify(cohort))
  } catch {
    // ignore quota errors
  }

  return cohort
}

function loadPreferences(): LocalPreferences {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return { ...DEFAULT_PREFERENCES }
    const parsed = JSON.parse(raw) as Partial<LocalPreferences>
    return {
      lastInstrument: (parsed.lastInstrument as InstrumentType) || DEFAULT_PREFERENCES.lastInstrument,
      a4Reference: (parsed.a4Reference as A4Reference) || DEFAULT_PREFERENCES.a4Reference,
      voiceEnabled: typeof parsed.voiceEnabled === 'boolean' ? parsed.voiceEnabled : DEFAULT_PREFERENCES.voiceEnabled,
      autoSelectString: typeof parsed.autoSelectString === 'boolean' ? parsed.autoSelectString : DEFAULT_PREFERENCES.autoSelectString,
      hasSeenMicEducation: typeof parsed.hasSeenMicEducation === 'boolean' ? parsed.hasSeenMicEducation : DEFAULT_PREFERENCES.hasSeenMicEducation,
    }
  } catch {
    return { ...DEFAULT_PREFERENCES }
  }
}

function savePreferences(prefs: LocalPreferences): void {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(prefs))
  } catch {
    // ignore quota errors
  }
}

export function useLocalPreferences() {
  const preferences: Ref<LocalPreferences> = ref(loadPreferences())
  const installCohort: Readonly<Ref<InstallCohort>> = ref(getInstallCohort())

  watch(
    preferences,
    (next) => {
      savePreferences(next)
    },
    { deep: true },
  )

  function updatePreferences(patch: Partial<LocalPreferences>): void {
    preferences.value = { ...preferences.value, ...patch }
  }

  function resetPreferences(): void {
    preferences.value = { ...DEFAULT_PREFERENCES }
  }

  return {
    preferences,
    installCohort,
    updatePreferences,
    resetPreferences,
  }
}
