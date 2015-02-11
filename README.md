# Kindle Highlights Fetcher

This little application will fetch a list of all your highlights from your kindle ebooks.

## Installation

    gem install kindle

## Usage

    kindle # Will prompt you for your login info. Don't worry it isn't stored.

### Preserve Amazon username on your local machine

    cp .env.sample .env

And then, change your username `AMAZON_USERNAME` in _.env_

### Fetch highlights of different domain

Add `KINDLE_DOMAIN=amazon.co.jp` to _.env_ (Example: Japanese site)

## Other usage and license

Hastily thrown together but incredibly useful since Amazon does not provide an API for kindle highlights. Please use this however you would like. This is licensed under MIT license.


© 2012 Matt Petty
[@lodestone](http://about.me/lodestone)
