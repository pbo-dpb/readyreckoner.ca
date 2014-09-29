// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery_ujs
//= require jed

var i18n = new Jed({});

/**
 * Translates strings.
 *
 * @param {String} msgid A string
 * @param {Object} options Replacement fields
 * @return {String} Returns the translated string
 */
function _(msgid, options) {
  var message = i18n.gettext(msgid);
  if (options == null) {
    return message;
  }
  else {
    return Jed.sprintf(message, options);
  }
}

/**
 * Formats a number a currency string.
 *
 * @param {Float} number A number
 * @return {String} Returns the number as a currency string
 * @see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/number_helper/number_to_currency_converter.rb
 * @see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/number_helper/number_to_delimited_converter.rb
 */
function number_to_currency(number) {
  var parts = number.toString().split('.');
  parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + _('number.currency.format.delimiter'));
  return _('number.currency.format.format').replace('%n', parts.join(_('number.currency.format.separator'))).replace('%u', _('number.currency.format.unit'));
}

/**
 * Collects variable values to pass to `solution()`.
 *
 * @return {Object} Returns each variable's value
 */
function variables() {
  var variables = {};
  $('input[type="range"]').each(function () {
    var $this = $(this);
    variables[$this.attr('id')] = parseFloat($this.val());
  });
  return variables;
}

$.getJSON('/translations/export/?locale=' + $('html').attr('lang')).done(function (messages) {
  i18n = new Jed({locale_data: {messages: messages}});
}).always(function () {
  $(function () {
    // Scrollspy
    $(document.body).scrollspy({
      target: '#sidebar'
    });
    $(window).on('load', function () {
      $(document.body).scrollspy('refresh');
    });

    // Affix
    setTimeout(function () {
      $('#sidebar').affix({
        offset: {
          top: function () {
            return (this.top = $('#sidebar').offset().top);
          }
        , bottom: function () {
            return (this.bottom = $('footer').outerHeight(true));
          }
        }
      });
    }, 100);

    $('input[type="range"]').change(function () {
      var message
        , number = solution(variables())
        , options = {number: number_to_currency(Math.abs(number))};

      if (number > 0) {
        message = _('Your changes would increase revenues by %(number)s.', options);
      }
      else if (number < 0) {
        message = _('Your changes would decrease revenues by %(number)s.', options);
      }
      else {
        message = '';
      }

      if (message) {
        $('#impacts-summary').html($('<div class="alert alert-info" role="alert">' + message + '</div>'));
      }
      else {
        $('#impacts-summary').empty();
      }
    }).each(function () {
      var $this = $(this);
      // Reset the simulator on refresh.
      $this.val($this.attr('value'));
    });
  });
});
