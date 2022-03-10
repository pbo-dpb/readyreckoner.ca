
> **⚠️  2022-03-10 : ARCHIVE **
> The rewritten Ready Reckoner has moved to the following repository:
> Le Simulateur Budgétaire réécrit a été déplacé vers le dépôt de code suivant :
> ➡️ https://github.com/pbo-dpb/RR--SB
> 
> This repository remains available for informational and research purposes.
> Ce dépôt de code demeure disponible à des fins d'information et de recherche.

---

# Ready Reckoner

[![Build Status](https://secure.travis-ci.org/opennorth/readyreckoner.ca.png)](http://travis-ci.org/opennorth/readyreckoner.ca)
[![Dependency Status](https://gemnasium.com/opennorth/readyreckoner.ca.png)](https://gemnasium.com/opennorth/readyreckoner.ca)
[![Coverage Status](https://coveralls.io/repos/opennorth/readyreckoner.ca/badge.png?branch=master)](https://coveralls.io/r/opennorth/readyreckoner.ca)
[![Code Climate](https://codeclimate.com/github/opennorth/readyreckoner.ca.png)](https://codeclimate.com/github/opennorth/readyreckoner.ca)

## Development

    bundle

### Generating the theme

From the [Bootswatch docs](http://bootswatch.com/help/#customization):

    git clone https://github.com/thomaspark/bootswatch.git
    cd bootswatch
    npm install

Edit `bower_components/bootstrap/less/bootstrap.less` by commenting out:

* `code`
* `forms`
* all components except:
  * `navs`
  * `alerts`
  * `tooltips`
  * `popovers`

Run:

    grunt swatch:lumen

Copy `lumen/bootstrap.min.css` to `app/assets/stylesheets` and change `../fonts` to `fonts`.

## Deployment

### Heroku

    heroku apps:create
    heroku addons:add pgbackups:auto-month
    heroku addons:add rediscloud
    heroku addons:add sendgrid

    heroku config:set SECRET_KEY_BASE=`bundle exec rake secret`
    heroku config:set ACTION_MAILER_HOST=www.readyreckoner.ca
    heroku config:set DEVISE_MAILER_SENDER=noreply@readyreckoner.ca
    heroku config:set REDIS_URL=`heroku config:get REDISCLOUD_URL`

In `config/environments/production.rb`:

```ruby
config.action_mailer.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :plain,
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_PASSWORD'],
  domain: 'heroku.com',
  enable_starttls_auto: true
}
```

## Bugs? Questions?

This repository is on GitHub: [http://github.com/opennorth/readyreckoner.ca](http://github.com/opennorth/readyreckoner.ca), where your contributions, forks, bug reports, feature requests, and feedback are greatly welcomed.

Copyright (c) 2014 Open North Inc., released under the MIT license
