# lita-gitcamp

Lita-gitcamp handler automaticly closes Basecamp todo when mentioning it Github issue closes.

We use the next workflow in our development process. We create todos list in basecamp for our customers, duplicate them in Github with description and link to Basecamp's todo. Using Github semantic commit messages we can close issues on Github but not on Basecamp. Lita-gitcamp is made to fix that issue.

## Installation

Add lita-gitcamp to your Lita instance's Gemfile:

``` ruby
gem "lita-gitcamp"
```

## Configuration

There are few configuration options are available

**rooms** - JIDs of rooms to send notification. Default value is :all.

**notify_chat** - Enables/disables chat notification when issue and todo are closed. Default: true.

**github_token** - Your Github API token

**basecamp_login** - Basecamp login. Gem uses basic auth and [bcx](https://github.com/paulspringett/bcx) gem.

**basecamp_password** - Basecamp password

**basecamp_account** - Basecamp account id

## Usage

Next commands will add and remove repositories from gitcamp all-seeing eye

``` ruby
add gitcamp repo http://github.com/EvercodeLab/maha2
remove gitcamp repo http://github.com/EvercodeLab/maha2
```

You also need to setup Hithub hook with /gitcamp path. Handler will listen it.
![Github hoob](https://photos-1.dropbox.com/t/0/AAAN2wL_FlUD6wXE_lZ982H8X5iYzdYWEUnDV6-7qY2P5A/12/11190302/png/1024x768/3/1383753600/0/2/Screenshot%202013-11-06%2018.48.40.png/Xf8_lMdwQ2SaZQ_sIeMlXqGzRmELetzy3mGhpCbzV7Q) 

## License

[MIT](http://opensource.org/licenses/MIT)
