const { defineConfig } = require('cypress')

module.exports = defineConfig({
  viewportWidth: 1280,
  viewportHeight: 1600,
  defaultCommandTimeout: 10000,
  video: true,
  e2e: {
    setupNodeEvents(on, config) {
      // No custom Node events are needed for this lab.
    },
  },
})
