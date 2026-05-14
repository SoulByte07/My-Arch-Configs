module.exports = {
  allowLocalFiles: true,
  themeSet: [
    require('path').join(require('os').homedir(), '.config/marp/theme.css')
  ],
  theme: 'catppuccin-mocha-mauve',
  html: true,
  pdf: { margin: 0 }
}
