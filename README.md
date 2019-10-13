# zcal

A calendar implementation in Z-Shell

# Features

* Fully implemented without exernal commands.
* Holiday highlight
    * Only Japanese holidays are implemented at the moment

# Installation

## Manually

1. Clone the repository
    ```
    git clone https://github.com/sakuro/zcal.git
    ```
2. Then `source` zcal.zsh from your ~/.zshrc.

# Customization

## Colors

You can specify output colors of dates using `zstyle`.

### Holidays

```
zstyle ':zcal:' holiday-color yellow
```

### Days in week

```
zstyle ':zcal:' day-colors blue cyan magenta gray green red yellow
```


# TODO

* Customization via zstyle
    * start-of-week
    * Holiday definition from locale
* Command line options for some display styles
* Homebrew formula
