function loadIce() {
  setTimeout(() => {
    let elm = document.querySelector('flt-glass-pane').shadowRoot.querySelector('canvas');
    console.log(elm);
    if (elm) {
      elm.setAttribute('data-craftercms-model-id', 'f2502f10-30a3-4308-6a8c-e79356219b00');
      elm.setAttribute('data-craftercms-model-path', '/site/website/about/index.xml');
      elm.setAttribute('data-craftercms-field-id', 'title_s');
      elm.setAttribute('data-craftercms-label', 'About');

      const script = document.createElement('script');
      script.src = 'http://localhost:8080/studio/static-assets/scripts/craftercms-guest.umd.js';
      document.head.appendChild(script);

      craftercms.guest.initInContextEditing({ path: '/site/website/about/index.xml' });
    }
  }, 6000);
}