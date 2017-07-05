# ruby-lastfm [![Build Status](https://secure.travis-ci.org/youpy/ruby-lastfm.png?branch=master)](http://travis-ci.org/youpy/ruby-lastfm)

A Ruby interface for Last.fm Web Services v2.0

## Synopsis

```ruby
require 'lastfm'

lastfm = Lastfm.new(api_key, api_secret)
token = lastfm.auth.get_token

# open 'http://www.last.fm/api/auth/?api_key=xxxxxxxxxxx&token=xxxxxxxx' and grant the application

lastfm.session = lastfm.auth.get_session(token: token)['key']

lastfm.track.love(artist: 'Hujiko Pro', track: 'acid acid 7riddim')
lastfm.track.scrobble(artist: 'Hujiko Pro', track: 'acid acid 7riddim')
lastfm.track.update_now_playing(artist: 'Hujiko Pro', track: 'acid acid 7riddim')
```

## Supported Rubies

* 1.9.3
* 2.0.0
* 2.1.0
* 2.2.0

## Supported API Methods

It supports methods which require [authentication](http://www.last.fm/api/authentication).

### Album

* [album.addTags](http://www.last.fm/api/show/album.addTags)
* [album.getBuylinks](http://www.last.fm/api/show/album.getBuylinks)
* [album.getInfo](http://www.last.fm/api/show?service=290)
* [album.getShouts](http://www.last.fm/api/show/album.getShouts)
* [album.getTags](http://www.last.fm/api/show/album.getTags)
* [album.getTopTags](http://www.last.fm/api/show/album.getTopTags)
* [album.removeTag](http://www.last.fm/api/show/album.removeTag)
* [album.search](http://www.last.fm/api/show/album.search)
* [album.share](http://www.last.fm/api/show/album.share)

### Artist

* ~~[artist.gets](http://www.last.fm/api/show?service=117)~~ deleted
* [artist.getInfo](http://www.last.fm/api/show?service=267)
* [artist.getSimilar](http://www.last.fm/api/show?service=267)
* [artist.getTags](http://www.last.fm/api/show?service=267)
* [artist.getTopAlbums](http://www.last.fm/api/show/artist.getTopAlbums)
* [artist.getTopFans](http://www.last.fm/api/show/artist.getTopFans)
* [artist.getTopTags](http://www.last.fm/api/show/artist.getTopTags)
* [artist.getTopTracks](http://www.last.fm/api/show/artist.getTopTracks)
* [artist.search](http://www.last.fm/api/show/artist.search)

### Auth

* [auth.getMobileSession](http://www.last.fm/api/show?service=266)
* [auth.getToken](http://www.last.fm/api/show?service=265)
* [auth.getSession](http://www.last.fm/api/show?service=125)

### Event

* ~~[event.getInfo](http://www.last.fm/api/show/event.getInfo)~~ deleted

### Radio

* [radio.getPlaylist](http://www.last.fm/api/show/radio.getPlaylist)

### Tag

* [tag.getInfo](http://www.last.fm/api/show/tag.getInfo)
* [tag.getTopAlbums](http://www.last.fm/api/show/tag.getTopAlbums)
* [tag.getTopArtists](http://www.last.fm/api/show/tag.getTopArtists)
* [tag.getTopTracks](http://www.last.fm/api/show/tag.getTopTracks)
* [tag.search](http://www.last.fm/api/show/tag.search)

### Tasteometer

* ~~[tasteometer.compare](http://www.last.fm/api/show/tasteometer.compare)~~ deleted

### Track

* [track.addTags](http://www.last.fm/api/show?service=304)
* [track.ban](http://www.last.fm/api/show?service=261)
* [track.getCorrection](http://www.last.fm/api/show?service=447)
* [track.getInfo](http://www.last.fm/api/show?service=356)
* [track.getSimilar](http://www.last.fm/api/show?service=319)
* [track.getTags](http://www.last.fm/api/show?service=320)
* [track.getTopFans](http://www.last.fm/api/show?service=312)
* [track.getTopTags](http://www.last.fm/api/show?service=289)
* [track.love](http://www.last.fm/api/show?service=260)
* [track.removeTag](http://www.last.fm/api/show?service=316)
* [track.scrobble](http://www.last.fm/api/show?service=443)
* [track.search](http://www.last.fm/api/show?service=286)
* [track.share](http://www.last.fm/api/show?service=305)
* [track.updateNowPlaying](http://www.last.fm/api/show?service=454)
* [track.unlove](http://www.last.fm/api/show/track.unlove)

### User

* [user.getFriends](http://www.last.fm/api/show?service=263)
* [user.getInfo](http://www.last.fm/api/show?service=344)
* [user.getLovedTracks](http://www.last.fm/api/show/user.getLovedTracks)
* [user.getNeighbours](http://www.last.fm/api/show?service=264)
* [user.getPersonalTags](http://www.last.fm/api/show/user.getPersonalTags)
* [user.getRecentTracks](http://www.last.fm/api/show?service=278)
* ~~[user.getRecommendedEvents](http://www.last.fm/api/show/user.getRecommendedEvents)~~ deleted
* [user.getRecommendedArtists](http://www.last.fm/api/show/user.getRecommendedArtists)
* [user.getTopArtists](http://www.last.fm/api/show/user.getTopArtists)
* [user.getTopAlbums](http://www.last.fm/api/show/user.getTopAlbums)
* [user.getTopTags](http://www.last.fm/api/show/user.getTopTags)
* [user.getTopTracks](http://www.last.fm/api/show/user.getTopTracks)
* [user.getWeeklyAlbumList](http://www.last.fm/api/show/user.getWeeklyAlbumChart)
* [user.getWeeklyArtistList](http://www.last.fm/api/show/user.getWeeklyArtistChart)
* [user.getWeeklyChartList](http://www.last.fm/api/show/group.getWeeklyChartList)
* [user.getWeeklyTrackList](http://www.last.fm/api/show/user.getWeeklyTrackChart)

### Geo

* ~~[geo.getEvents](http://www.last.fm/api/show?service#270)~~ deleted

### Group

* [group.getMembers](http://www.last.fm/api/show/group.getMembers)

### Library

* [library.getArtists](http://www.last.fm/api/show?service#322)
* [library.getTracks](http://www.last.fm/api/show/library.getTracks)

### Chart

* [chart.getHypedArtists](http://www.last.fm/api/show/chart.getHypedArtists)
* [chart.getHypedTracks](http://www.last.fm/api/show/chart.getHypedTracks)
* [chart.getLovedTracks](http://www.last.fm/api/show/chart.getLovedTracks)
* [chart.getTopArtists](http://www.last.fm/api/show/chart.getTopArtists)
* [chart.getTopTags](http://www.last.fm/api/show/chart.getTopTags)
* [chart.getTopTracks](http://www.last.fm/api/show/chart.getTopTracks)

## Installation

### Archive Installation

```
rake install
```

### Gem Installation

```
gem update --system
gem install gemcutter
gem tumble
gem install lastfm
```

## Features/Problems

## Comitters

see https://github.com/youpy/ruby-lastfm/contributors 

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 youpy. See LICENSE for details.
