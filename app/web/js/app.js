const FIXED_ATTRIBUTES = {
  '/': {
    "data-craftercms-model-id": "8d7f21fa-5e09-00aa-8340-853b7db302da",
    "data-craftercms-model-path": "/site/website/index.xml",
    "data-craftercms-label": "Home"
  },
  '/about': {
    "data-craftercms-model-id": "f2502f10-30a3-4308-6a8c-e79356219b00",
    "data-craftercms-model-path": "/site/website/about/index.xml",
    "data-craftercms-label": "About"
  }
}

function initICE(path) {
  let elm = document.querySelector('flt-glass-pane');
  if (elm) {
    const attributes = FIXED_ATTRIBUTES[path];
    for (let i = 0; i < Object.keys(attributes).length; i++) {
      const key = Object.keys(attributes)[i];
      const value = attributes[key];
      elm.setAttribute(key, value);
    }
    craftercms.xb.initInContextEditing({ path: attributes['data-craftercms-model-path'] });
  }
}