function initICE(path, id, label) {
  let elm = document.querySelector('flt-glass-pane');
  if (elm) {
    const attributes = {
      'data-craftercms-model-id': id,
      'data-craftercms-model-path': path,
      'data-craftercms-label': label
    };
    for (let i = 0; i < Object.keys(attributes).length; i++) {
      const key = Object.keys(attributes)[i];
      const value = attributes[key];
      elm.setAttribute(key, value);
    }
    craftercms.xb.initInContextEditing({ path: attributes['data-craftercms-model-path'] });
  }
}