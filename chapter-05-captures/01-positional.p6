if "Hello, world" ~~ / (\w+) ', ' (\w+) / {
    say "Greeting: $0";     # Output: Greeting: Hello
    say "Audience: $1";     # Output: Audience: world
}

