webshim.setOptions({
  'forms-ext': {
    replaceUI: 'true'
  , types: 'range'
  , range: {
      classes: 'show-ticklabels show-activelabeltooltip'
    }
  }
});

webshim.polyfill('forms forms-ext');
