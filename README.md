# quorum
experimental app for me to play with: redis, sinatra, minitest

problem:
human readable namespacing introduces scarcity and competition, where first come has a "market" advantage giving people semantic control without accountability

weird toy im working on to solve said problem:
the app will act like a democratic URN resolver within a regular website

- URLs will all be `h/<hash>` and unique
- URNs will all be human readable and unique
- a URN will map to a URL via a quorum
-- a URN can have only one URL active at any time
--- or a relaxed constraint could be productive too?
-- any number of URLs can point to a URN
--- any number of URNs can point to a URL?
--- URN -> URL -> URN -> URL ok?
- a URN will track competing claims by all URLs claiming it
-
