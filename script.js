// Small interactions: set year, handle nav toggle, and reveal on scroll
window.addEventListener('DOMContentLoaded', () => {
  const year = String(new Date().getFullYear());
  document.querySelectorAll('#year').forEach(el => { el.textContent = year; });

  const nav = document.querySelector('.main-nav');
  const toggle = document.querySelector('.nav-toggle');
  if (nav && toggle) {
    toggle.addEventListener('click', () => {
      const isOpen = nav.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(isOpen));
      toggle.setAttribute('aria-label', isOpen ? 'Close navigation' : 'Open navigation');
    });

    // Close mobile nav when clicking a link
    nav.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        if (nav.classList.contains('open')) {
          nav.classList.remove('open');
          toggle.setAttribute('aria-expanded', 'false');
          toggle.setAttribute('aria-label', 'Open navigation');
        }
      });
    });
  }

  // Highlight active nav link
  const currentPage = (window.location.pathname.split('/').pop() || 'index.html');
  const normalizeHref = (href) => {
    const parts = href.split('/');
    const last = parts.pop() || '';
    return last || 'index.html';
  };

  document.querySelectorAll('.main-nav a').forEach(link => {
    const href = link.getAttribute('href');
    if (!href) return;
    if (normalizeHref(href) === currentPage) {
      link.classList.add('active');
      link.setAttribute('aria-current', 'page');
    }
  });

  const reveals = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window && reveals.length) {
    const obs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          obs.unobserve(entry.target);
        }
      });
    }, { threshold: 0.15 });
    reveals.forEach(r => obs.observe(r));
  } else {
    reveals.forEach(r => r.classList.add('visible'));
  }
});
