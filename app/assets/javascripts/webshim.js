webshim.setOptions({
  'forms-ext': {
    replaceUI: 'true'
  , types: 'range'
  , range: {
      classes: 'show-ticklabels'
    }
  }
});

webshim.polyfill('forms forms-ext');
