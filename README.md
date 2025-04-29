# FINALIST

The FINAL LIST app you'll hopefully ever need.  Pun 110% intended.

This is a port of the [golang backend](https://github.com/nathanvy/finalist) to Ruby on Rails.  I wrote the original app in Lisp towards the end of COVID and did not know about a lot of the common conventions when it comes to CRUD apps.  As a result the database schema is... nonstandard.

The Go rewrite kept the same legacy schema for compatibility and lack-of-free-time reasons.  

Rails, relying as it does on "convention over configuration" isn't able to work with this janky schema out of the box, so there's a fair amount of configuration for now.  This version will keep the legacy schema as well as the silly API design until a future revision.
