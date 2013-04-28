# Ruby on Rails Tutorial: sample application

This is the sample application for
[*Ruby on Rails Tutorial: Learn Rails by Example*](http://railstutorial.org/)
by [le cafe automatique](http://lecafeautomatique.co.uk/).

# Work in progress

I'm trying to create/implement a deployment flow I'm happy with.
Initially I'm basing it in the capistrano-gitflow repository from 'technicalpickles, but:

1. hacking everything together in the deploy.rb as I learn
2. updating some bits for Capistrano 2.x
3. modifying the tag format and the promotion approach.

Essentially:

* two environments: 'staging' and 'production'.
* 'staging' checks SHA-1 hashes and automatically creates tags.
* 'production' doesn't care about the SHA-1 hashes and promotes tags to 'production' tags.
* 'production' tags can be promoted from the last 'staging' or from any other tag.

I would like 'production' tags to make some reference to the promoted tags, but didn't make my mind about the format. Let me think about it.

Also, I would prefer if 'staging' tags would behave the same way, allowing the 'staging' deployment of any other tag version if necessary (check old versions, etc). And ideally the same behaviour should be aplicable to any other non-production environment (testing, demoing, feature deployment, ...).