# FPFK Gathanga Church — Local Site

A lightweight static website for the FPFK Gathanga church.

## Run locally

```powershell
cd C:\Users\USER\FPFK-site
python -m http.server 8000
# then open http://localhost:8000
```

## Customizing the site

- Place your `logo.png` in `assets/`
- Add gallery images in `assets/gallery/` (e.g., `1.jpg`, `2.jpg`)
- Optionally add a hero background image at `assets/hero.jpg` (or the site will use a gradient fallback)
- Update the text content in the HTML pages as needed

## Pages

- `index.html` — Homepage
- `sermons.html` — Sermons & media
- `events.html` — Upcoming events
- `donate.html` — Giving information
