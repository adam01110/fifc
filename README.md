<div align="center">

# FzFish

_fzf-powered fish completions_

[![CI](https://github.com/adam01110/fzfish/actions/workflows/ci.yml/badge.svg)](https://github.com/adam01110/fzfish/actions/workflows/ci.yml)

FzFish brings fzf powers on top of fish completion engine and allows customizable completion rules.

Fork of [gazorby/fifc](https://github.com/gazorby/fifc) with additional features and customizations.

</div>

![gif usage](assets/demo.gif)

## Requirements

- [fish](https://github.com/fish-shell/fish-shell) 3.4.0+
- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat) or `cat`
- [timg](https://github.com/hzeller/timg) or `file`
- [hexyl](https://github.com/sharkdp/hexyl) or `file`
- [fd](https://github.com/sharkdp/fd) or `find`
- [eza](https://github.com/eza-community/eza), [exa](https://github.com/ogham/exa), or `ls`
- [ripgrep](https://github.com/BurntSushi/ripgrep) or `pcregrep`
- [procs](https://github.com/dalance/procs) or `ps`

## Features

- Preview/open any file: text with [bat](https://github.com/sharkdp/bat) or `cat`; images, gifs, and pdfs with [timg](https://github.com/hzeller/timg) or `file`; archives with `7z` or `file`; binaries with [hexyl](https://github.com/sharkdp/hexyl) or `file`
- Preview/open command's man page
- Preview/open function definitions
- Preview/open full option description when completing commands
- Recursively search for files and folders when completing paths (using [fd](https://github.com/sharkdp/fd) or `find`)
- Preview directory content with [eza](https://github.com/eza-community/eza), [exa](https://github.com/ogham/exa), or `ls`, using a vertical one-entry-per-line layout by default
- Preview process trees (using [procs](https://github.com/dalance/procs) or `ps`)
- Interactive depth controls for file and directory search inside the `fzf` picker
- Reapply bindings automatically when `fish_key_bindings` changes
- Modular: easily add your own completion rules
- Properly handle paths with spaces (needs fish 3.4+)

## Install

### Using Fisher

Remember to install the requirements listed above.

```fish
fisher install adam01110/fzfish
```

The command name is `fzfish`.

### Using Nix

This repository's flake now exposes the plugin directly, so you can choose either this flake or the package from my NUR repo.

#### Directly from this flake

Remember to install the requirements listed above.

```nix
{
  inputs.fzfish.url = "github:adam01110/fzfish";

  outputs = {nixpkgs, fzfish, ...}: {
    homeConfigurations.me = let
      system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};
    in
      {
        programs.fish.plugins = [
          {
            name = "fzfish";
            src = fzfish.packages.${system}.default;
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
      name = "fzfish";
      src = nur.repos.adam01110.fishPlugins.fzfish;
    }
  ];
}
```

## Usage

You can optionally set a custom editor after install:

```fish
set -Ux fzfish_editor <your-favorite-editor>
```

If `fzfish_editor` is not set, `fzfish` uses `$EDITOR` automatically.

And enjoy built-in completions!

By default `fzfish` overrides `tab`, but you can assign another keybinding:

```fish
# Bind fzf completions to ctrl-x
set -U fzfish_keybinding \cx
```

`fzfish` will also by default use `rm` to remove temporary files; this can be changed:

```fish
# Use trash instead of rm
set -U fzfish_rm_cmd trash
```

To append a custom fzf command, for example to disable the `--exact` flag and increase the fuzziness:

```fish
set -U fzfish_custom_fzf_opts +e
```

To enable popup style (like atuin), where fzf appears in a floating window under the prompt instead of taking over the full terminal:

```fish
set -U fzfish_popup true
```

This uses `--height ~50%` by default.

You can customize the height:

```fish
set -U fzfish_popup_height 30%
```

`fzfish` can use modern tools if available:

| Prefer                                           | Fallback to | Used for                                  | Custom options                            |
| ------------------------------------------------ | ----------- | ----------------------------------------- | ----------------------------------------- |
| [bat](https://github.com/sharkdp/bat)            | `cat`       | Preview files                             | `$fzfish_bat_opts`                          |
| [timg](https://github.com/hzeller/timg)          | `file`      | Preview images, gif, pdf etc              | `$fzfish_timg_opts`                         |
| [hexyl](https://github.com/sharkdp/hexyl)        | `file`      | Preview binaries                          | `$fzfish_hexyl_opts`                        |
| [fd](https://github.com/sharkdp/fd)              | `find`      | Complete paths                            | `$fzfish_fd_opts`                           |
| [eza](https://github.com/eza-community/eza)      | `exa`, `ls` | Preview directories                       | `$fzfish_eza_opts`, `$fzfish_exa_opts`, `$fzfish_ls_opts` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `pcregrep`  | Search options in man pages               | -                                         |
| [procs](https://github.com/dalance/procs)        | `ps`        | Complete processes and preview their tree | `$fzfish_procs_opts`                        |

Custom options can be added for any of the commands used by `fzfish` using the variable mentioned in the above table.

If `timg` falls back to block rendering in a terminal that supports a graphics protocol, force it with `fzfish_timg_pixelation`:

- `set -U fzfish_timg_pixelation kitty`
- `set -U fzfish_timg_pixelation sixel`

Show line number when previewing files:

- `set -U fzfish_bat_opts --style=numbers`

Don't use quotes in variables, set them as a list: `set -U fzfish_eza_opts --icons --tree`

Show hidden files by default:

- `set -U fzfish_show_hidden true`

Enable case-insensitive completion matching:

- `set -U fzfish_case_insensitive true`

When enabled, fzf will perform case-insensitive matching for all completions. This is particularly useful for `cd` and file path completions where you don't want to worry about exact case matching.

Wrap long lines in the default preview pane:

- `set -U fzfish_wrap_default_preview true`

When enabled, the generic fallback preview uses `fzf --preview-window wrap`, so long descriptions wrap instead of requiring horizontal scrolling.

Override the directory preview command entirely:

- `set -U fzf_preview_dir_cmd 'eza -1a --color=always --icons'`

When set, FZFISH uses `fzf_preview_dir_cmd` instead of its built-in directory preview command. The selected directory is passed as the final argument.

Interactive depth controls for file and directory search:

- By default, `alt-left` / `ctrl-h` decrease depth and `alt-right` / `ctrl-l` increase it
- By default, `alt-1` .. `alt-9` jump directly to a specific depth
- Customize them with `fzfish_depth_decrease_keybindings`, `fzfish_depth_increase_keybindings`, and `fzfish_depth_direct_keybindings`

Path search starts at depth 1, and the picker prompt shows the active depth as `d:N>` while you adjust it.

```fish
set -U fzfish_depth_decrease_keybindings alt-left ctrl-h
set -U fzfish_depth_increase_keybindings alt-right alt-l
set -U fzfish_depth_direct_keybindings alt-1 alt-2 alt-3 alt-4 alt-5
```

## Write your own rules

Custom rules can easily be added using the `fzfish` command. Actually, all builtin rules are added this way: see [conf.d/fzfish.fish](https://github.com/gazorby/fifc/blob/52ff966511ea97ed7be79db469fe178784e22fd8/conf.d/fifc.fish)

See `fzfish -h` for more details.

Basically, a rule allows you to trigger some commands based on specific conditions.

A condition can be either:

- A regex that must match commandline before the cursor position
- An arbitrary command that must exit with a non-zero status

If conditions are met, you can bind custom commands:

- **preview:** Command used for fzf preview
- **source:** Command that feeds fzf input
- **open:** Command binded to `fzfish_open_keybinding` (defaults to ctrl-o)

All commands have access to the following variable describing the completion context:

| Variable           | Description                                                                                        | Command availability |
| ------------------ | -------------------------------------------------------------------------------------------------- | -------------------- |
| `fzfish_candidate`   | Currently selected item in fzf                                                                     | all except source    |
| `fzfish_commandline` | Commandline part before the cursor position                                                        | all                  |
| `fzfish_token`       | Last token from the commandline                                                                    | all                  |
| `fzfish_group`       | Group to which fish suggestions belong (possible values: directories, files, options or processes) | all                  |
| `fzfish_extracted`   | Extracted string from the currently selected item using the `extracted` regex, if any              | all except source    |
| `fzfish_query`       | fzf query. On source command, it is the initial fzf query (passed through `--query` option)        | all                  |

### **fzfish_group** values

fzfish test completion items to set `fzfish_group` with the following conditions:

| Group       | Condition                                                    |
| ----------- | ------------------------------------------------------------ |
| directories | All completion items are directories                         |
| files       | Items can be either files _or_ directories                   |
| options     | All items match the following regex: `\h+\-+\h*$`            |
| processes   | All items match the following regex `^[0-9]+$` (list of PID) |

### Matching order

By default, fzfish evaluate all rules in the order in which they have been defined and stops at the first where all conditions are met.
It does this each time it has to resolve source, preview and open commands.

Take the following scenario:

```fish
# Rule 1
fzfish -n 'test "$fzfish_group" = files' -p 'bat $fzfish_candidate'
# Rule 2
fzfish -n 'string match "*.json" "$fzfish_candidate"' -p 'bat -l json $fzfish_candidate'
```

When completing path, `$fzfish_group` will be set to "files" so the first rule will always be valid in that case, and the second one will never be reached.

Another example:

```fish
# Rule 1
fzfish --condition 'test "$fzfish_group" = files' --preview 'bat $fzfish_candidate'
# Rule 2
fzfish --condition 'test "$fzfish_group" = files' --source 'fd . --color=always --hidden $HOME'
```

Here, even if both rules have the same conditions, they won't interfere because fzfish has to resolve source commands _before_ the preview commands, so order doesn't matter in this case.

### Override builtin rules

If you want to write your own rule based on the same conditions as one of the built-in ones, you can use fzfish `--order` option.
It tells fzfish to evaluate the rule in a predefined order, so you can set it to 1 to make sure it will be evaluated first.

When omitting the `--order`, the rule will be declared unordered and will be evaluated _after_ all other ordered rules, and all other unordered rules defined before.

All built-in rules are unordered.

### Examples

Here is how the built-in rule for file preview/open is implemented:

```fish
fzfish \
    # If selected item is a file
    -n 'test -f "$fzfish_candidate"' \
    # bind `_fzfish_preview_file` to preview command
    -p _fzfish_preview_file \
    # and `_fzfish_preview_file` when pressing ctrl-o
    -o _fzfish_open_file
```

Interactively search packages in archlinux:

```fish
fzfish \
    -r '^(pacman|paru)(\\h*\\-S)?\\h+' \
    -s 'pacman --color=always -Ss "$fzfish_token" | string match -r \'^[^\\h+].*\'' \
    -e '.*/(.*?)\\h.*' \
    -f "--query ''" \
    -p 'pacman -Si "$fzfish_extracted"'
```

![gif usage](assets/pacman.gif)

Search patterns in files and preview matches when commandline starts with `**<pattern>` (using [ripgrep](https://github.com/burntsushi/ripgrep) and [batgrep](https://github.com/eth-p/bat-extras/blob/master/doc/batgrep.md#bat-extras-batgrep)):

```fish
fzfish \
    -r '.*\*{2}.*' \
    -s 'rg --hidden -l --no-messages (string match -r -g \'.*\*{2}(.*)\' "$fzfish_commandline")' \
    -p 'batgrep --color --paging=never (string match -r -g \'.*\*{2}(.*)\' "$fzfish_commandline") "$fzfish_candidate"' \
    -f "--query ''" \
    -o 'batgrep --color (string match -r -g \'.*\*{2}(.*)\' "$fzfish_commandline") "$fzfish_candidate" | less -R' \
    -O 1
```

![gif usage](assets/batgrep.gif)

## Credits

Thanks [PatrickF1](https://github.com/PatrickF1) (and collaborators!), for the great [fzf.fish](https://github.com/PatrickF1/fzf.fish) plugin which inspired me for the command-based configuration, and from which I copied the ci workflow.

FzFish is a fork of [gazorby/fifc](https://github.com/gazorby/fifc). All credit for the original implementation goes to the original author and contributors.

Additional features in this fork were taken or adapted from the following upstream PRs and forks:

- [ollehu](https://github.com/ollehu) for [gazorby/fifc#49](https://github.com/gazorby/fifc/pull/49), which added configurable `rm`, custom `fzf` options, and custom keybinding fixes
- [HydroH](https://github.com/HydroH) for [gazorby/fifc#52](https://github.com/gazorby/fifc/pull/52), which preserves `fzfish_fd_opts` / `fzfish_find_opts` in directory completion
- [dieggsy](https://github.com/dieggsy) for [gazorby/fifc#54](https://github.com/gazorby/fifc/pull/54), which prefers `eza` in directory previews
- [justbispo](https://github.com/justbispo) for [gazorby/fifc#60](https://github.com/gazorby/fifc/pull/60), which fixes escaped `fzf` query handling
- [justbispo/fifc](https://github.com/justbispo/fifc) for binding persistence, path display fixes, and apostrophe-safe completion
- [thalesmello/fifc](https://github.com/thalesmello/fifc) for ignored-file search, per-group query history, incomplete-path completion, wrapped preview support, and man-page jump fixes
- [schmas/fifc](https://github.com/schmas/fifc) for case-insensitive matching, hidden-file mode, interactive depth controls, vertical directory preview with custom override support, and typed-directory matching improvements
