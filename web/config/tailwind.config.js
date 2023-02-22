/** @type {import('tailwindcss').Config} */

const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: ['src/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },

      animaiton: {
        pulse: "pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite"
      },

      keyframes: {
        pulse: {
          "0%, 100%": {
            opacity: .25,
          },
          "50%": {
            opacity: .75,
          }
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
}

