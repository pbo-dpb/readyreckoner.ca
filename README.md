# Ready Reckoner

## Development

    bundle

### Generating the theme

From the [Bootswatch docs](http://bootswatch.com/help/#customization):

    git clone https://github.com/thomaspark/bootswatch.git
    cd bootswatch
    npm install

Edit `bower_components/bootstrap/less/bootstrap.less` by commenting out:

* `glyphicons`
* `code`
* `forms`
* all components except `navs` and `alerts`

Run:

    grunt swatch:lumen

Copy `lumen/bootstrap.min.css` to `app/assets/stylesheets`.

## Deployment

    heroku config:set SECRET_KEY_BASE=`bundle exec rake secret`
