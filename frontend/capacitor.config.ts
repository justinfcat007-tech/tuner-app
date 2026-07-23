import type { CapacitorConfig } from '@capacitor/cli'

const config: CapacitorConfig = {
  appId: 'com.tunerapp.mobile',
  appName: '调音器',
  webDir: 'dist',
  android: {
    allowMixedContent: false,
  },
}

export default config
