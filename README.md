# X

#### A Crystal interface to the X API.

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  x:
    github: sferik/x-crystal
```

Then run:

    shards install

## Usage

```crystal
require "x"

x_credentials = {
  api_key:             "INSERT YOUR X API KEY HERE",
  api_key_secret:      "INSERT YOUR X API KEY SECRET HERE",
  access_token:        "INSERT YOUR X ACCESS TOKEN HERE",
  access_token_secret: "INSERT YOUR X ACCESS TOKEN SECRET HERE",
}

# Initialize an X API client with your OAuth credentials
x_client = X::Client.new(**x_credentials)

# Get data about yourself
x_client.get("users/me")
# {"data"=>{"id"=>"7505382", "name"=>"Erik Berlin", "username"=>"sferik"}}

# Post a tweet
tweet = x_client.post("tweets", '{"text":"Hello, World! (from @gem)"}')
# {"data"=>{"edit_history_tweet_ids"=>["1234567890123456789"], "id"=>"1234567890123456789", "text"=>"Hello, World! (from @gem)"}}

# Delete the tweet you just posted
x_client.delete("tweets/#{tweet["data"]["id"]}")
# {"data"=>{"deleted"=>true}}

# Initialize an API v1.1 client
v1_client = X::Client.new(base_url: "https://api.twitter.com/1.1/", **x_credentials)

# Request your account settings
v1_client.get("account/settings.json")

# Initialize an X Ads API client
ads_client = X::Client.new(base_url: "https://ads-api.twitter.com/12/", **x_credentials)

# Request your ad accounts
ads_client.get("accounts")
```

## History and Philosophy

This library is a port of the [X Ruby library](https://github.com/sferik/x-ruby), which is a rewrite of the [Twitter Ruby library](https://github.com/sferik/twitter). The Ruby and Crystal version have the same basic interface and design philosophy, but this is not a strict guarantee.

## Development

1. Checkout and repo:

       git checkout git@github.com:sferik/x-crystal.git

2. Enter the repo’s directory:

       cd x-crystal

3. Install dependencies via Shards:

       shards install

4. Ensure all tests pass:

       crystal spec

5. Create a new branch for your feature or bug fix:

       git checkout -b my-new-feature

6. Write your feature or bug fix

7. Ensure the code is formatted properly:

       crystal tool format

8. Ensure the tests still pass:

       crystal spec

9. Write tests to cover your new feature and ensure they pass:

       crystal spec

10. Commit your changes:

        git commit -am "Add some feature"

11. Push to the branch:

        git push origin my-new-feature

12. Open a Pull Request on GitHub

## Contributors

- [Erik Berlin](https://github.com/sferik) - creator and maintainer

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
