# Bulba

An Obsidian theme. Bulba is a fork of [Primary](https://github.com/primary-theme/obsidian) by Cecilia May ([Ko-fi](https://ko-fi.com/ceciliamay)), with its own palettes and a modular SCSS build.

## Install

Copy `manifest.json` and `theme.css` into `<vault>/.obsidian/themes/Bulba/`, then pick Bulba under Settings → Appearance → Themes.

Most options are exposed through the [Style Settings](https://github.com/mgmeyers/obsidian-style-settings) plugin.

## Build

The source lives in `src/` as SCSS partials and compiles to a single `theme.css`.

| Command | Description |
|---------|-------------|
| `npm install` | Install sass (first time only) |
| `npm run build` | Compile `src/main.scss` to `theme.css` |
| `npm run dev` | Rebuild on save |
| `npm run set-bg -- <image>` | Swap the new-tab background image (needs ImageMagick and Python 3) |

## License

GNU General Public License v3, the same as Primary. See [LICENSE](LICENSE).
