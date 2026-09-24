# SK Smartomation — Website

A single-page, animation-rich website for SK Smartomation (home theater, whole-home audio, smart lighting, LED walls and smart security). Built as plain HTML/CSS/JS — no build tools, no installs required to run it.

## How to preview it

**Easiest:** double-click `index.html` to open it in your browser.

**Recommended (fixes a couple of minor browser quirks with local files):** serve the folder with any simple local server, for example:

```
# Python (usually pre-installed on Mac/Linux)
cd sk-smartomation
python3 -m http.server 8080
# then open http://localhost:8080 in your browser
```

or, if you have Node.js installed:

```
npx serve sk-smartomation
```

## How to update the site — the short version

All editable text lives in the **`content/`** folder — one clearly-named file per section, so you can go straight to the piece you want without hunting through one giant file.

| I want to change...                        | Edit this file                                          |
|--------------------------------------------|-----------------------------------------------------------|
| Company name, tagline, logo, menu           | `content/company.js`                                     |
| The homepage hero (room scene headlines)    | `content/hero.js`                                         |
| The About section + the 4 stat counters     | `content/about.js`                                        |
| The 6 service cards                         | `content/services.js`                                     |
| The 4-step process timeline                 | `content/process.js`                                      |
| Projects — add, remove, or edit any project | `content/projects.js`                                     |
| Client logos (the sliding strip)            | `content/clients.js`                                       |
| Email, phone, address, map, social links    | `content/contact.js`                                       |
| Project photos or videos                    | `assets/images/projects/...` and `assets/videos/...` (see `assets/README.md`) |
| Logo file itself                            | `assets/images/logo/logo-mark.svg`                        |
| Colors / fonts (whole site)                 | top of `css/style.css` (the `:root { ... }` variables)     |
| Colors of just the homepage hero            | the `.hero-pin-wrap { ... }` variable block right below `:root` |

Every file in `content/` is plain JavaScript but every field is labeled with a comment — you're just editing text between quotes. After saving any file, refresh the page in your browser to see the change; there's no build step.

## Folder structure

```
sk-smartomation/
├── index.html          The page itself (structure only — text comes from /content)
├── content/             ← THE FOLDER YOU'LL EDIT MOST — one file per section
│   ├── company.js        Company name, tagline, logo, nav menu
│   ├── hero.js            Homepage hero / room-scene headlines
│   ├── about.js           About section + stat counters
│   ├── services.js        The 6 service cards
│   ├── process.js         The 4-step process timeline
│   ├── projects.js        Portfolio — add/edit/remove projects here
│   ├── clients.js         Client logos for the sliding strip
│   └── contact.js         Email, phone, address, map, social links
├── css/
│   └── style.css        All styling, colors, layout, animations
├── js/
│   ├── main.js            Site logic + scroll animations (shouldn't need editing)
│   └── vendor/            Local copy of the GSAP animation library (offline-safe)
└── assets/
    ├── README.md           Full guide to photos/videos — read this before adding media
    ├── images/
    │   ├── logo/
    │   ├── room/            The animated "empty room → smart home" illustration layers
    │   ├── doodles/         Small decorative icons
    │   └── projects/        One folder per project (project-1, project-2, ...)
    └── videos/
        ├── hero/
        └── projects/
```

## What's on the page

1. **Hero** — an empty room that comes alive as you scroll: ceiling lighting fades in, a screen appears on the wall, then floor-standing speakers slide in.
2. **About** — company story with animated stat counters.
3. **Services** — six service cards (Home Theater & Audio, Smart Lighting, LED Walls & Displays, Smart Security, Whole-Home Automation, Room Acoustics & Design).
4. **Process** — a 4-step "Consult → Design → Install → Enjoy" timeline with a line that draws in as you scroll.
5. **Projects** — a filterable-style grid with an animated project counter; click any project to open a detail popup with a photo gallery and system list.
6. **Clients** — an auto-scrolling strip of client logos.
7. **Contact / Footer** — email, phone, address, an embedded Google Map, and social links.

## Publishing it live

This is a static site, so it can be hosted almost anywhere for free or very cheaply:

- **Netlify / Vercel** — drag-and-drop the whole `sk-smartomation` folder onto their dashboard.
- **GitHub Pages** — push the folder to a GitHub repo and enable Pages in settings.
- **Any regular web host** (GoDaddy, Hostinger, etc.) — upload the whole folder via FTP; `index.html` should sit at the root of the domain (or the folder you want the site to load from).

No server-side code, database, or build step is required.

## Tech notes

- Animations are powered by GSAP + ScrollTrigger (bundled locally in `js/vendor/`, so the site works even without an internet connection to a CDN).
- Fonts are Playfair Display (headings) and Manrope (body text) via Google Fonts, with safe fallback fonts (Georgia / system sans-serif) if the internet connection to Google Fonts is unavailable.
- No frameworks, no build step, no `npm install` needed to run the site.
- Fully responsive — tested down to small phones (~360px wide) and landscape phones, up through tablets and large desktops.
- The top navigation bar keeps one constant color scheme at all times; it never swaps from dark to light as you scroll.
- The hero's ceiling lights, screen and speakers each have a soft animated glow so they read as "powered on" once revealed — see `#layer-ceiling`, `#layer-screen`, `#layer-speaker-l/-r` in `css/style.css` if you want to tune the glow color or intensity.
