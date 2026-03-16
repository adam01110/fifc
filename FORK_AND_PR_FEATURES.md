# Fork and Pull Request Feature Comparison

Snapshot: 2026-03-15

Base repository (upstream): `gazorby/fifc`

Scope:

- Open pull requests in the upstream repository `gazorby/fifc`
- Current fork under review:
  - `adam01110/fzfish`
- Active forks requested by the user:
  - `justbispo/fifc`
  - `thalesmello/fifc`
  - `schmas/fifc`

Method:

- Pull requests were read from the public GitHub API.
- Fork branches were fetched locally and compared against `origin/main`.
- A separate subagent summary was run for each fork-only commit.

Legend:

- `Y` = exact or clearly present
- `N` = intentionally not planned for merge
- `~` = approximate / partial / broader variant
- `subset` = narrower duplicate of a broader change
- `-` = not present

## Executive view

| Item | What it gives you | Notes |
| --- | --- | --- |
| `adam01110/fzfish` | Exact PR `#49`, exact PR `#52`, exact PR `#54`, and exact PR `#60`; `#49` already includes the PR `#61` behavior | Current fork state: custom rm command, custom fzf opts, preserved directory search opts, eza-first directory preview, fixed escaped query handling, correct man-page line jumps, per-group `fzf` query history, ignored-file search, optional hidden-file display, optional case-insensitive matching, optional wrapped default preview, vertical directory preview with optional custom command, no forced extra Tab bind, binding reapplication when `fish_key_bindings` changes, correct short-name display when the current path contains spaces, apostrophe-safe path completion, improved incomplete-path file completion, interactive depth controls for file and directory search, and better typed-directory-path matching |
| `justbispo/fifc` | Most of PR `#49`, exact `#52`, exact `#60`, equivalent `#61`, plus extra bug fixes | Best fork if the goal is "bundle several existing PR/fork fixes" |
| `thalesmello/fifc` | Independent UX and completion behavior changes | Does not really aggregate the open PRs |
| `schmas/fifc` | Larger UX redesign: hidden files, case-insensitive mode, depth controls, preview changes | Only approximate overlap with `#52` and `#54` |
| PR `#36` | Configurable `fzf` launcher / `fzf-tmux` support | Not present in the three requested forks |
| PR `#54` | `eza`-first directory preview | Exact in `adam01110/fzfish`; approximate in `schmas/fifc` |

## Open pull requests

| PR | Commits | Main feature(s) | Files changed | Overlap |
| --- | --- | --- | --- | --- |
| [#36](https://github.com/gazorby/fifc/pull/36) `add fzf-tmux support` | `92228dd` | Adds configurable `fifc_fzf_cmd` so the base `fzf -d \t` launcher can be replaced by `fzf-tmux` or another wrapper. | `functions/_fifc.fish` | Independent. No matching fork among the three requested. |
| [#49](https://github.com/gazorby/fifc/pull/49) `Allow override of rm and custom fzf options` | `90421f8`, `235aace` | Adds `fifc_rm_cmd`; adds `fifc_custom_fzf_opts`; stops forcing a Tab binding so `fifc_keybinding` is respected. | `README.md`, `conf.d/fifc.fish`, `functions/_fifc.fish`, `functions/_fifc_action.fish`, test files | `justbispo/fifc` contains this PR exactly and extends it. Overlaps with `#61`. |
| [#52](https://github.com/gazorby/fifc/pull/52) `Make directory completions respect fifc_fd_opts` | `d7a44c1` | Directory completion appends `-t d` / `-type d` instead of overwriting existing `fifc_fd_opts` / `fifc_find_opts`. | `functions/_fifc_source_directories.fish` | Exact in `adam01110/fzfish` and `justbispo/fifc`; approximate in `schmas/fifc`. |
| [#54](https://github.com/gazorby/fifc/pull/54) `Use eza instead of exa` | `b79d4bc`, `c269c50` | Prefers `eza` for directory preview, but keeps `exa` fallback for compatibility. | `README.md`, `functions/_fifc_preview_dir.fish` | Exact in `adam01110/fzfish`; approximate in `schmas/fifc`. |
| [#60](https://github.com/gazorby/fifc/pull/60) `Fix escaping fzf query` | `030b7fa` | Replaces broken query trimming with `string unescape`, fixing escaped path queries. | `functions/_fifc.fish` | Exact in `adam01110/fzfish` and `justbispo/fifc`. |
| [#61](https://github.com/gazorby/fifc/pull/61) `fix: remove extra tab binding` | `6733303` | Removes the unconditional `bind --mode $mode \t _fifc`. | `conf.d/fifc.fish` | Subset of `#49`; equivalent behavior already exists in `justbispo/fifc`. |

## Fork to PR coverage

| Fork | Ahead commits | Exact PR coverage | Approximate/shared changes | Not included |
| --- | --- | --- | --- | --- |
| `adam01110/fzfish` | 19 | `#49`, `#52`, `#54`, `#60` | `#61` equivalent via `#49` behavior; also includes the fork-only binding persistence fix, working custom `fzf` options, path-with-spaces display fix, apostrophe-safe completion fix, exact man-page jump, incomplete-path file completion fix, per-group `fzf` query history, ignored-file search, optional hidden-file display, optional case-insensitive matching, optional wrapped default preview, vertical directory preview with optional custom command, interactive depth controls, and typed-directory matching fix | `#36` |
| `justbispo/fifc` | 11 | `#49`, `#52`, `#60` | `#61` equivalent via `#49` behavior | `#36`, `#54` |
| `thalesmello/fifc` | 5 | - | No exact PR carry; only loose UX theme overlap with `#61` because Tab behavior changes inside fzf | `#36`, `#49`, `#52`, `#54`, `#60`, `#61` |
| `schmas/fifc` | 20 | - | `#52` approximate; `#54` approximate | `#36`, `#49`, `#60`, `#61` |

## Shared-change matrix

### PR-derived features

| Feature | #36 | #49 | #52 | #54 | #60 | #61 | adam01110 | justbispo | thalesmello | schmas |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Custom `fzf` launcher / `fzf-tmux` support (`fifc_fzf_cmd`) | Y | - | - | - | - | - | N | - | - | - |
| Respect `fifc_keybinding` without forced Tab bind | - | Y | - | - | - | Y | Y | Y | - | - |
| Custom temp-file removal command (`fifc_rm_cmd`) | - | Y | - | - | - | - | Y | Y | - | - |
| Extra `fzf` flags via config (`fifc_custom_fzf_opts`) | - | Y | - | - | - | - | Y | Y | - | - |
| Directory completion preserves existing `fifc_fd_opts` / `fifc_find_opts` | - | - | Y | - | - | - | Y | Y | - | ~ |
| Prefer `eza` for directory preview | - | - | - | Y | - | - | ~ | - | - | ~ |
| Fix escaped `fzf` query handling | - | - | - | - | Y | - | Y | Y | - | - |

### Fork-only features

This is the fork overlay for features that are not coming from the open PR list.

| Feature | Meaning in practice | adam01110 | justbispo | thalesmello | schmas |
| --- | --- | --- | --- | --- | --- |
| Reapply bindings when `fish_key_bindings` changes | FIFC keybinding survives switching Fish keymaps. | Y | Y | - | - |
| Actually pass configured `fifc_custom_fzf_opts` to `fzf` | User-defined extra `fzf` flags are really appended instead of being silently ignored. | Y | Y | - | - |
| Fix path display when current path contains spaces | Keeps short relative names when working inside directories with spaces. | Y | Y | - | - |
| Fix completion for paths containing apostrophes | Paths containing `'` do not break the generated `fzf` command. | Y | Y | - | - |
| Wrap preview window for default source | Long preview lines wrap instead of needing horizontal scrolling; in `adam01110/fzfish` this is opt-in via `fifc_wrap_default_preview=true`. | ~ | - | Y | - |
| Open selected man-page option at the correct line | Opening an option jumps to the exact matching line in the man page. | Y | - | Y | - |
| Limit home-directory search depth to 1 | Completing from `~` only scans the first level by default. | N | - | Y | - |
| Store per-group `fzf` query history | Files, options, and other groups keep separate query history. | Y | - | Y | - |
| Search ignored files too (`fd --no-ignore`) | Results include files normally hidden by ignore rules. | Y | - | Y | - |
| Improve file completion for incomplete path strings | Partial paths like `src/mai` keep normal completion behavior instead of falling into a bad recursive search. | Y | - | Y | - |
| Show hidden files via `fifc_show_hidden=true` | Opt-in dotfile visibility in normal completion results. | Y | - | - | Y |
| Case-insensitive matching via `fifc_case_insensitive=true` | Opt-in case-insensitive matching inside `fzf`. | Y | - | - | Y |
| `Tab` / `Shift-Tab` navigate entries inside fzf | `Tab` keys move selection instead of acting as the old multi-select key. | N | - | Y | Y |
| Configurable multi-select key instead of Tab | Multi-select moves off `Tab` and can be reassigned. | N | - | - | Y |
| Interactive depth controls for file/directory search | Search depth can be changed live from inside the picker. | Y | - | - | Y |
| Vertical directory preview with optional custom command | Directory preview becomes a one-entry-per-line list and can be overridden. | Y | - | - | Y |
| Better matching when completing inside an already-typed directory path | Typed directory prefix becomes search scope instead of part of the exact match text. | Y | - | - | Y |

### Fork overlay by fork

| Fork | Fork-only feature set |
| --- | --- |
| `adam01110/fzfish` | Binding persistence, working custom `fzf` opts, spaces-safe path display, apostrophe-safe completion, exact man-page jump, incomplete-path completion, per-group history, ignored-file search, hidden-file mode, case-insensitive mode, wrapped default preview mode, vertical directory preview with optional custom command, interactive depth controls, typed-directory matching. |
| `justbispo/fifc` | Binding persistence, working custom `fzf` opts, spaces-safe path display, apostrophe-safe completion. |
| `thalesmello/fifc` | Wrapped preview, exact man-page jump, shallow `~` search, per-group history, ignored-file search, `Tab` / `Shift-Tab` navigation, incomplete-path completion. |
| `schmas/fifc` | Hidden-file mode, case-insensitive mode, `Tab` / `Shift-Tab` navigation, configurable multi-select key, interactive depth controls, vertical directory preview, typed-directory matching. |

## Fork details

### `adam01110/fzfish`

Net effect:

- Exact PR bundle (`#49`, `#52`, `#54`, `#60`) plus several extra completion fixes and selective UX additions from other forks, including interactive depth controls and vertical directory preview override support.
- The fork-only changes are not a UI redesign; they make existing completion behavior survive more shell states and more path shapes, with the wrapped default preview added as an opt-in toggle rather than a default behavior change.

What the fork-only features actually do:

- Binding persistence: when Fish switches keymaps by changing `fish_key_bindings` (for example after enabling vi bindings), FIFC now re-runs its bind setup automatically. Before this, the configured FIFC key could disappear until a new shell was opened.
- Custom `fzf` flags really apply: `functions/_fifc.fish` now passes `$fifc_custom_fzf_opts` into the `fzf` command line, so user-supplied extra flags are not silently dropped.
- Paths with spaces display correctly: file completion now compares the current directory against the raw path instead of an already shell-escaped one. Before this, working inside a directory whose name contained spaces could make FIFC show long/full paths where short relative names were expected.
- Apostrophe-safe completion: the typed query is now escaped correctly before being passed to `fzf`. Before this, names containing `'` could break quoting and abort completion.
- Correct man-page jump: when FIFC opens a selected CLI option from a man page, it now strips pager control sequences, finds the matching line number first, and opens `less` directly at that line instead of relying on a regex search inside pager output.
- Incomplete path completion: if the user has typed only part of a path segment such as `src/mai`, FIFC now falls back to Fish's parsed completion list instead of trying to recursively search under a non-directory prefix. That restores useful completions for partially typed paths.
- Per-group `fzf` query history: FIFC now stores query history in separate files per completion group such as files, directories, or options, so history from one picker type does not pollute another.
- Search ignored files too: the `fd` path now adds `--no-ignore`, so results can include files normally hidden by `.gitignore` or other ignore rules.
- Hidden-file mode: `set -U fifc_show_hidden true` makes FIFC include dotfiles and hidden directories in normal search results instead of only showing them when the typed path itself already starts with `.`.
- Case-insensitive mode: `set -U fifc_case_insensitive true` adds `fzf -i`, so matching no longer depends on letter case.
- Wrapped default preview mode: `set -U fifc_wrap_default_preview true` makes the generic fallback preview use `fzf --preview-window wrap`, so long descriptions wrap without changing the default behavior for users who do not opt in.
- Vertical directory preview: directory previews now use one entry per line, prefer `eza -1a`, fall back to `exa -1a` or `ls -A -F`, and can be fully overridden with `fzf_preview_dir_cmd`.
- Interactive depth controls: file and directory completion starts at depth 1, the prompt shows the active depth, `alt-up` / `alt-down` and `ctrl-j` / `ctrl-k` step depth live, and `alt-1`..`alt-9` jump directly to a chosen depth without dropping the current picker session.
- Better typed-directory matching: when the token already includes a directory prefix like `foo/bar/ba`, FIFC now treats `foo/bar/` as search scope and matches only on the remaining leaf text. Before this, the whole prefix stayed in the exact `fzf` query and could block matches inside that directory.

### `justbispo/fifc`

Net effect:

- Closest thing to a "merge the good open PRs" fork.
- Contains PR `#49`, PR `#52`, PR `#60`, and the PR `#61` behavior.
- Adds four extra fixes not present in the open PR list: binding persistence, custom `fzf` flags actually being forwarded, spaces in path display, and apostrophe-safe completion.

What the fork-only features actually do:

- Binding persistence: moves FIFC binding setup into a function that also runs when `fish_key_bindings` changes, so switching between Fish keymaps does not drop the FIFC keybinding.
- Custom `fzf` flags really apply: fixes the variable name used when building the `fzf` command. Before this, `fifc_custom_fzf_opts` existed but user-supplied extra flags were silently ignored.
- Paths with spaces display correctly: separates raw-path checks from shell-escaped command output, so FIFC still recognizes `$PWD` correctly when directory names contain spaces and keeps showing short relative names.
- Apostrophe-safe completion: escapes the query safely before passing it to `fzf`, preventing unbalanced-quote failures when paths contain `'`.

### `thalesmello/fifc`

Net effect:

- Independent UX/completion stack, not a bundle of the existing open PRs.
- No exact PR carry from `#36`, `#49`, `#52`, `#54`, `#60`, or `#61`.

What the fork-only features actually do:

- Wrapped preview: the generic/default preview pane uses `--preview-window wrap`, so long lines wrap inside the preview instead of forcing horizontal scrolling.
- Correct man-page jump: when FIFC opens a selected CLI option from a man page, it now computes the matching line number first and opens `less` at that line. This is more precise than searching by regex inside raw pager output.
- Shallower `~` search: completions rooted directly at `$HOME` are limited to depth 1. That cuts noise and cost when completing from `~` without changing deeper searches elsewhere.
- Single-select navigation model: inside `fzf`, `Tab` and `Shift-Tab` move the cursor instead of toggling multiselect, FIFC runs in single-select mode, and each completion group gets its own persisted query history file.
- Search ignored files too: the `fd` path adds `--no-ignore`, so results can include files normally hidden by `.gitignore` or other ignore rules.
- Incomplete path completion: partial path fragments are no longer treated as directory roots for recursive search, so incomplete strings keep using the regular Fish completion list until they become a real directory path.

### `schmas/fifc`

Net effect:

- Largest fork-only UX redesign of the three.
- Final branch keeps hidden-file support, case-insensitive mode, depth controls, new preview behavior, and fzf keybinding changes.
- Approximate overlap with PR `#52` and PR `#54`, but not exact carries.

What the fork-only features actually do:

- Hidden-file mode: `set -U fifc_show_hidden true` makes file and directory completion include dotfiles by default, and the same behavior is preserved when reloading results at different search depths.
- Case-insensitive mode: `set -U fifc_case_insensitive true` adds `fzf -i`, so case mismatches stop blocking results.
- Picker navigation redesign: `Tab` and `Shift-Tab` move up and down inside the picker, multiselect moves to `ctrl-space` by default or `fifc_multi_keybinding`, and toggling selection no longer jumps to the next row automatically.
- Vertical directory preview: directory preview becomes a one-entry-per-line listing, prefers `eza`, falls back to `exa` or `ls`, and can be fully replaced with `fzf_preview_dir_cmd`.
- Natural ranking restored: removes `--scheme=path` after earlier experiments, so matching stops over-weighting full path structure and shallow/basename-style matches rank more naturally again.
- Interactive depth controls: completion starts at depth 1, the prompt shows the current depth, `alt-up` / `alt-down` and `ctrl-j` / `ctrl-k` adjust it live, and `alt-1`..`alt-9` jump straight to a chosen depth.
- Better typed-directory matching: once a directory prefix is already typed, FIFC clears that prefix from the active query so matching works on the remaining basename text rather than the whole path string.

## Practical merge notes

If the goal is to build a personal fork with the highest-value low-overlap changes:

1. Start with the independent open PRs: `#36`, `#52`, `#54`, `#60`.
2. Choose `#49` or `#61`, not both; `#61` is redundant if you already take `#49` or `justbispo/fifc`.
3. `adam01110/fzfish` now also includes the `justbispo/fifc` working custom-`fzf`-options fix (`051febd`) and apostrophe-safe completion fix (`b3f5886`), the `thalesmello/fifc` wrapped-preview feature (`d74393b`), exact man-page jump fix (`0861074`), per-group `fzf` history feature (`3ef1942`), and ignored-file search (`6f1096c`), and the `schmas/fifc` hidden-file option (`1b165ac`), case-insensitive matching option (`0ca852d`, `8773786`), vertical directory preview override (`1c6d080`), interactive depth controls (`58408e8`, `f8f31bc`, `2b98131`), and typed-directory matching fix (`4b305f1`), in addition to the earlier binding-persistence fix (`e70150d`) and paths-with-spaces display fix (`caf694e`).
4. Treat `thalesmello/fifc` and `schmas/fifc` as UX forks, not straightforward PR bundles; several of their remaining changes alter navigation, ranking, preview style, or default search scope.

## Bottom line

- `adam01110/fzfish` now carries exact PR `#49`, `#52`, `#54`, and `#60` behavior in one fork, plus the fork-only binding-persistence, working custom `fzf` options, path-with-spaces display, apostrophe-safe completion, exact man-page jump, incomplete-path file completion, per-group `fzf` query history, ignored-file search, optional hidden-file display, optional case-insensitive matching, optional wrapped default preview, vertical directory preview with optional custom command, interactive depth controls, and typed-directory matching fixes.
- `justbispo/fifc` is no longer uniquely ahead on the apostrophe-safe completion fix; its remaining distinction is the same broader PR bundle plus its own branch history.
- PR `#36` is still unique and would need to be merged separately.
- `thalesmello/fifc` and `schmas/fifc` are best mined selectively rather than merged wholesale.
