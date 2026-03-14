<div align="center">

# fifc

_fish fzf completions_

[![CI](https://github.com/adam01110/fifc/actions/workflows/ci.yml/badge.svg)](https://github.com/adam01110/fifc/actions/workflows/ci.yml)

fifc brings fzf powers on top of fish completion engine and allows customizable completion rules

Fork of [gazorby/fifc](https://github.com/gazorby/fifc) with additional features and customizations

</div>

![gif usage](assets/demo.gif)

## Requirements

- [fish](https://github.com/fish-shell/fish-shell) 3.4.0+
- [bat](https://github.com/sharkdp/bat) or `cat`
- [chafa](https://github.com/hpjansson/chafa) or `file`
- [hexyl](https://github.com/sharkdp/hexyl) or `file`
- [fd](https://github.com/sharkdp/fd) or `find`
- [eza](https://github.com/eza-community/eza), [exa](https://github.com/ogham/exa), or `ls`
- [ripgrep](https://github.com/BurntSushi/ripgrep) or `pcregrep`
- [procs](https://github.com/dalance/procs) or `ps`
- [broot](https://github.com/Canop/broot)

## Features

- Preview/open any file: text with [bat](https://github.com/sharkdp/bat) or `cat`; images, gifs, pdfs, and archives with [chafa](https://github.com/hpjansson/chafa) or `file`; binaries with [hexyl](https://github.com/sharkdp/hexyl) or `file`
- Preview/open command's man page
- Preview/open function definitions
- Preview/open full option description when completing commands
- Recursively search for files and folders when completing paths (using [fd](https://github.com/sharkdp/fd) or `find`)
- Preview directory content with [eza](https://github.com/eza-community/eza), [exa](https://github.com/ogham/exa), or `ls`
- Preview process trees (using [procs](https://github.com/dalance/procs) or `ps`)
- `Tab` and `Shift-Tab` navigation inside the `fzf` picker
- Reapply bindings automatically when `fish_key_bindings` changes
- Modular: easily add your own completion rules
- Properly handle paths with spaces (needs fish 3.4+)

## Install

### Using Fisher

Remember to install the requirements listed above.

```fish
fisher install adam01110/fifc
```

### Using Nix

This repository's flake now exposes the plugin directly, so you can choose either this flake or the package from my NUR repo.

#### Directly from this flake

Remember to install the requirements listed above.

```nix
{
  inputs.fifc.url = "github:adam01110/fifc";

  outputs = {nixpkgs, fifc, ...}: {
    homeConfigurations.me = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
    in
      {
        programs.fish.plugins = [
          {
            name = "fifc";
            src = fifc.packages.${system}.default;
          }
        ];
      };
  };
}
```

#### From NUR

Install NUR first: <https://github.com/nix-community/NUR#installation>

Remember to install the requirements listed above.

```nix
{
  programs.fish.plugins = [
    {
      name = "fifc";
      src = nur.repos.adam01110.fishPlugins.fifc;
    }
  ];
}
```

## Usage

You only need to set one setting after install:

```fish
set -Ux fifc_editor <your-favorite-editor>
```

And enjoy built-in completions!

By default fifc override `tab`, but you can assign another keybinding:

```fish
# Bind fzf completions to ctrl-x
set -U fifc_keybinding \cx
```

fifc will also by default use `rm` to remove temporary files, this can changed:

```fish
# Use trash instead of rm
set -U fifc_rm_cmd trash
```

To append a custom fzf command, for example to disable the `--exact` flag and increase the fuzziness:

```fish
set -U fifc_custom_fzf_opts +e
```

fifc can use modern tools if available:

| Prefer                                           | Fallback to | Used for                                  | Custom options                            |
| ------------------------------------------------ | ----------- | ----------------------------------------- | ----------------------------------------- |
| [bat](https://github.com/sharkdp/bat)            | `cat`       | Preview files                             | `$fifc_bat_opts`                          |
| [chafa](https://github.com/hpjansson/chafa)      | `file`      | Preview images, gif, pdf etc              | `$fifc_chafa_opts`                        |
| [hexyl](https://github.com/sharkdp/hexyl)        | `file`      | Preview binaries                          | `$fifc_hexyl_opts`                        |
| [fd](https://github.com/sharkdp/fd)              | `find`      | Complete paths                            | `$fifc_fd_opts`                           |
| [eza](https://github.com/eza-community/eza)      | `exa`, `ls` | Preview directories                       | `$fifc_eza_opts`, `$fifc_exa_opts`, `$fifc_ls_opts` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `pcregrep`  | Search options in man pages               | -                                         |
| [procs](https://github.com/dalance/procs)        | `ps`        | Complete processes and preview their tree | `$fifc_procs_opts`                        |
| [broot](https://github.com/Canop/broot)          | -           | Explore directory trees                   | `$fifc_broot_opts`                        |

Custom options can be added for any of the commands used by fifc using the variable mentioned in the above table.

Example:

Show line number when previewing files:

- `set -U fifc_bat_opts --style=numbers`

Don't use quotes in variables, set them as a list: `set -U fifc_eza_opts --icons --tree`

Show hidden files by default:

- `set -U fifc_show_hidden true`

Enable case-insensitive completion matching:

- `set -U fifc_case_insensitive true`

When enabled, fzf will perform case-insensitive matching for all completions. This is particularly useful for `cd` and file path completions where you don't want to worry about exact case matching.

## Write your own rules

Custom rules can easily be added using the `fifc` command. Actually, all builtin rules are added this way: see [conf.d/fifc.fish](https://github.com/gazorby/fifc/blob/52ff966511ea97ed7be79db469fe178784e22fd8/conf.d/fifc.fish)

See `fifc -h` for more details.

Basically, a rule allows you to trigger some commands based on specific conditions.

A condition can be either:

- A regex that must match commandline before the cursor position
- An arbitrary command that must exit with a non-zero status

If conditions are met, you can bind custom commands:

- **preview:** Command used for fzf preview
- **source:** Command that feeds fzf input
- **open:** Command binded to `fifc_open_keybinding` (defaults to ctrl-o)

All commands have access to the following variable describing the completion context:

| Variable           | Description                                                                                        | Command availability |
| ------------------ | -------------------------------------------------------------------------------------------------- | -------------------- |
| `fifc_candidate`   | Currently selected item in fzf                                                                     | all except source    |
| `fifc_commandline` | Commandline part before the cursor position                                                        | all                  |
| `fifc_token`       | Last token from the commandline                                                                    | all                  |
| `fifc_group`       | Group to which fish suggestions belong (possible values: directories, files, options or processes) | all                  |
| `fifc_extracted`   | Extracted string from the currently selected item using the `extracted` regex, if any              | all except source    |
| `fifc_query`       | fzf query. On source command, it is the initial fzf query (passed through `--query` option)        | all                  |

### **fifc_group** values

fifc test completion items to set `fifc_group` with the following conditions:

| Group       | Condition                                                    |
| ----------- | ------------------------------------------------------------ |
| directories | All completion items are directories                         |
| files       | Items can be either files _or_ directories                   |
| options     | All items match the following regex: `\h+\-+\h*$`            |
| processes   | All items match the following regex `^[0-9]+$` (list of PID) |

### Matching order

By default, fifc evaluate all rules in the order in which they have been defined and stops at the first where all conditions are met.
It does this each time it has to resolve source, preview and open commands.

Take the following scenario:

```fish
# Rule 1
fifc -n 'test "$fifc_group" = files' -p 'bat $fifc_candidate'
# Rule 2
fifc -n 'string match "*.json" "$fifc_candidate"' -p 'bat -l json $fifc_candidate'
```

When completing path, `$fifc_group` will be set to "files" so the first rule will always be valid in that case, and the second one will never be reached.

Another example:

```fish
# Rule 1
fifc --condition 'test "$fifc_group" = files' --preview 'bat $fifc_candidate'
# Rule 2
fifc --condition 'test "$fifc_group" = files' --source 'fd . --color=always --hidden $HOME'
```

Here, even if both rules have the same conditions, they won't interfere because fifc has to resolve source commands _before_ the preview commands, so order doesn't matter in this case.

### Override builtin rules

If you want to write your own rule based on the same conditions as one of the built-in ones, you can use fifc `--order` option.
It tells fifc to evaluate the rule in a predefined order, so you can set it to 1 to make sure it will be evaluated first.

When omitting the `--order`, the rule will be declared unordered and will be evaluated _after_ all other ordered rules, and all other unordered rules defined before.

All built-in rules are unordered.

### Examples

Here is how the built-in rule for file preview/open is implemented:

```fish
fifc \
    # If selected item is a file
    -n 'test -f "$fifc_candidate"' \
    # bind `_fifc_preview_file` to preview command
    -p _fifc_preview_file \
    # and `_fifc_preview_file` when pressing ctrl-o
    -o _fifc_open_file
```

Interactively search packages in archlinux:

```fish
fifc \
    -r '^(pacman|paru)(\\h*\\-S)?\\h+' \
    -s 'pacman --color=always -Ss "$fifc_token" | string match -r \'^[^\\h+].*\'' \
    -e '.*/(.*?)\\h.*' \
    -f "--query ''" \
    -p 'pacman -Si "$fifc_extracted"'
```

![gif usage](assets/pacman.gif)

Search patterns in files and preview matches when commandline starts with `**<pattern>` (using [ripgrep](https://github.com/burntsushi/ripgrep) and [batgrep](https://github.com/eth-p/bat-extras/blob/master/doc/batgrep.md#bat-extras-batgrep)):

```fish
fifc \
    -r '.*\*{2}.*' \
    -s 'rg --hidden -l --no-messages (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline")' \
    -p 'batgrep --color --paging=never (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline") "$fifc_candidate"' \
    -f "--query ''" \
    -o 'batgrep --color (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline") "$fifc_candidate" | less -R' \
    -O 1
```

![gif usage](assets/batgrep.gif)

## Credits

Thanks [PatrickF1](https://github.com/PatrickF1) (and collaborators!), for the great [fzf.fish](https://github.com/PatrickF1/fzf.fish) plugin which inspired me for the command-based configuration, and from which I copied the ci workflow.

This is a fork of [gazorby/fifc](https://github.com/gazorby/fifc). All credit for the original implementation goes to the original author and contributors.
