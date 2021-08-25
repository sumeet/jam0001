If you're a Ruby programmer and have rbenv or similar installed, then just

```console
bundle
bundle exec main.rb | tee OUTPUT
```

Otherwise you need octokit-rb. It's in the AUR, so 

```console
yay -S ruby-octokit
ruby main.rb
```
