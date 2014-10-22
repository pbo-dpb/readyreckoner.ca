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
// http://getbootstrap.com/customize/ with only Affix and Scrollspy.
//
//= require bootstrap.min.js
//= require jed.js

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
 * Formats a number a percentage string.
 *
 * @param {Float} number A number
 * @return {String} Returns the number as a percentage string
 */
function number_to_percentage(number) {
  var parts = number.toString().split('.');
  parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + _('number.percentage.format.delimiter'));
  return _('number.percentage.format.format').replace('%n', parts.join(_('number.format.separator')));
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

$.getJSON('/admin/translations/export/?locale=' + $('html').attr('lang')).done(function (messages) {
  // Load the translations via AJAX.
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
            return (this.bottom = $('footer').outerHeight(true) + 75);
          }
        }
      });
    }, 100);

    $('input[type="range"]').change(function () {
      // Display a message.
      var message
        , css_class
        , number = solution(variables())
        , options = {
            number: number_to_currency(Math.abs(number / 1000000))
          , percentage: number_to_percentage(Math.abs(number / total_revenue * 100).toFixed(2))
          };

      if (number > 0) {
        message = _('Your changes would <em>increase</em> revenues by %(number)s million, or %(percentage)s of total revenues.', options);
        css_class = 'alert-info';
      }
      else if (number < 0) {
        message = _('Your changes would <em>decrease</em> revenues by %(number)s million, or %(percentage)s of total revenues.', options);
        css_class = 'alert-danger';
      }
      else {
        message = '';
      }

      if (message) {
        $('#impacts-summary,#impacts-sidebar').html($('<div class="alert ' + css_class + '" role="alert">' + message + '</div>'));
        // Pulsate the alert to draw attention.
        $('#impacts-sidebar').animate({opacity: 0}, 'fast').animate({opacity: 1}, 'fast');
      }
      else {
        $('#impacts-summary,#impacts-sidebar').empty();
      }
    }).each(function () {
      // Reset the simulator on refresh.
      var $this = $(this);
      $this.val($this.attr('value'));
    });
  });
});
