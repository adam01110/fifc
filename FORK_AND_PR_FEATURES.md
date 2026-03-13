# Fork and Pull Request Feature Comparison

Snapshot: 2026-03-13

Base repository: `gazorby/fifc`

Scope:
- Open pull requests in `gazorby/fifc`
- Current fork under review:
  - `adam01110/fifc`
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
- `~` = approximate / partial / broader variant
- `subset` = narrower duplicate of a broader change
- `-` = not present

## Executive view

| Item | What it gives you | Notes |
| --- | --- | --- |
| `adam01110/fifc` | Exact PR `#49`, exact PR `#52`, exact PR `#54`, and exact PR `#60`; `#49` already includes the PR `#61` behavior | Current fork state: custom rm command, custom fzf opts, preserved directory search opts, eza-first directory preview, fixed escaped query handling, no forced extra Tab bind, binding reapplication when `fish_key_bindings` changes, correct short-name display when the current path contains spaces, and apostrophe-safe path completion |
| `justbispo/fifc` | Most of PR `#49`, exact `#52`, exact `#60`, equivalent `#61`, plus extra bug fixes | Best fork if the goal is "bundle several existing PR/fork fixes" |
| `thalesmello/fifc` | Independent UX and completion behavior changes | Does not really aggregate the open PRs |
| `schmas/fifc` | Larger UX redesign: hidden files, case-insensitive mode, depth controls, preview changes | Only approximate overlap with `#52` and `#54` |
| PR `#36` | Configurable `fzf` launcher / `fzf-tmux` support | Not present in the three requested forks |
| PR `#54` | `eza`-first directory preview | Exact in `adam01110/fifc`; approximate in `schmas/fifc` |

## Open pull requests

| PR | Commits | Main feature(s) | Files changed | Overlap |
| --- | --- | --- | --- | --- |
| [#36](https://github.com/gazorby/fifc/pull/36) `add fzf-tmux support` | `92228dd` | Adds configurable `fifc_fzf_cmd` so the base `fzf -d \t` launcher can be replaced by `fzf-tmux` or another wrapper. | `functions/_fifc.fish` | Independent. No matching fork among the three requested. |
| [#49](https://github.com/gazorby/fifc/pull/49) `Allow override of rm and custom fzf options` | `90421f8`, `235aace` | Adds `fifc_rm_cmd`; adds `fifc_custom_fzf_opts`; stops forcing a Tab binding so `fifc_keybinding` is respected. | `README.md`, `conf.d/fifc.fish`, `functions/_fifc.fish`, `functions/_fifc_action.fish`, test files | `justbispo/fifc` contains this PR exactly and extends it. Overlaps with `#61`. |
| [#52](https://github.com/gazorby/fifc/pull/52) `Make directory completions respect fifc_fd_opts` | `d7a44c1` | Directory completion appends `-t d` / `-type d` instead of overwriting existing `fifc_fd_opts` / `fifc_find_opts`. | `functions/_fifc_source_directories.fish` | Exact in `adam01110/fifc` and `justbispo/fifc`; approximate in `schmas/fifc`. |
| [#54](https://github.com/gazorby/fifc/pull/54) `Use eza instead of exa` | `b79d4bc`, `c269c50` | Prefers `eza` for directory preview, but keeps `exa` fallback for compatibility. | `README.md`, `functions/_fifc_preview_dir.fish` | Exact in `adam01110/fifc`; approximate in `schmas/fifc`. |
| [#60](https://github.com/gazorby/fifc/pull/60) `Fix escaping fzf query` | `030b7fa` | Replaces broken query trimming with `string unescape`, fixing escaped path queries. | `functions/_fifc.fish` | Exact in `adam01110/fifc` and `justbispo/fifc`. |
| [#61](https://github.com/gazorby/fifc/pull/61) `fix: remove extra tab binding` | `6733303` | Removes the unconditional `bind --mode $mode \t _fifc`. | `conf.d/fifc.fish` | Subset of `#49`; equivalent behavior already exists in `justbispo/fifc`. |

## Fork to PR coverage

| Fork | Ahead commits | Exact PR coverage | Approximate/shared changes | Not included |
| --- | --- | --- | --- | --- |
| `adam01110/fifc` | 7 | `#49`, `#52`, `#54`, `#60` | `#61` equivalent via `#49` behavior; also includes the fork-only binding persistence fix, path-with-spaces display fix, and apostrophe-safe completion fix | `#36` |
| `justbispo/fifc` | 11 | `#49`, `#52`, `#60` | `#61` equivalent via `#49` behavior | `#36`, `#54` |
| `thalesmello/fifc` | 5 | - | No exact PR carry; only loose UX theme overlap with `#61` because Tab behavior changes inside fzf | `#36`, `#49`, `#52`, `#54`, `#60`, `#61` |
| `schmas/fifc` | 20 | - | `#52` approximate; `#54` approximate | `#36`, `#49`, `#60`, `#61` |

## Shared-change matrix

### PR-derived features

| Feature | #36 | #49 | #52 | #54 | #60 | #61 | adam01110 | justbispo | thalesmello | schmas |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Custom `fzf` launcher / `fzf-tmux` support (`fifc_fzf_cmd`) | Y | - | - | - | - | - | - | - | - | - |
| Respect `fifc_keybinding` without forced Tab bind | - | Y | - | - | - | Y | Y | Y | - | - |
| Custom temp-file removal command (`fifc_rm_cmd`) | - | Y | - | - | - | - | Y | Y | - | - |
| Extra `fzf` flags via config (`fifc_custom_fzf_opts`) | - | Y | - | - | - | - | Y | Y | - | - |
| Directory completion preserves existing `fifc_fd_opts` / `fifc_find_opts` | - | - | Y | - | - | - | Y | Y | - | ~ |
| Prefer `eza` for directory preview | - | - | - | Y | - | - | Y | - | - | ~ |
| Fix escaped `fzf` query handling | - | - | - | - | Y | - | Y | Y | - | - |

### Fork-only features

| Feature | adam01110 | justbispo | thalesmello | schmas |
| --- | --- | --- | --- | --- |
| Reapply bindings when `fish_key_bindings` changes | Y | Y | - | - |
| Fix path display when current path contains spaces | Y | Y | - | - |
| Fix completion for paths containing apostrophes | Y | Y | - | - |
| Wrap preview window for default source | - | - | Y | - |
| Open selected man-page option at the correct line | - | - | Y | - |
| Limit home-directory search depth to 1 | - | - | Y | - |
| Store per-group `fzf` query history | - | - | Y | - |
| Search ignored files too (`fd --no-ignore`) | - | - | Y | - |
| Improve file completion for incomplete path strings | - | - | Y | - |
| Show hidden files via `fifc_show_hidden=true` | - | - | - | Y |
| Case-insensitive matching via `fifc_case_insensitive=true` | - | - | - | Y |
| `Tab` / `Shift-Tab` navigate entries inside fzf | - | - | Y | Y |
| Configurable multi-select key instead of Tab | - | - | - | Y |
| Interactive depth controls for file/directory search | - | - | - | Y |
| Vertical directory preview with optional custom command | - | - | - | Y |
| Better matching when completing inside an already-typed directory path | - | - | - | Y |

## Fork details

### `justbispo/fifc`

Net effect:
- Closest thing to a "merge the good open PRs" fork.
- Contains PR `#49`, PR `#52`, PR `#60`, and the PR `#61` behavior.
- Adds three extra fixes not present in the open PR list: binding persistence, spaces in path display, and apostrophe-safe completion.

Commit-by-commit:

| Commit | Status | Summary |
| --- | --- | --- |
| `d7a44c1` | active | Exact PR `#52`: preserves existing `fifc_fd_opts` / `fifc_find_opts` when directory completion adds directory-only filters. |
| `90421f8` | active | First PR `#49` commit: adds `fifc_rm_cmd`, adds `fifc_custom_fzf_opts`, and removes the forced extra Tab binding. |
| `235aace` | active | Second PR `#49` commit: adjusts `_fifc_action` handling around custom `fzf` options; this is the PR `#49` head commit. |
| `030b7fa` | active | Exact PR `#60`: fixes escaped `fzf` query handling with `string unescape`. |
| `f8f9aca` | merge-only | Merge of an external branch carrying the same PR `#49` behavior already listed above. |
| `8fdbc31` | merge-only | Merge of the same query-escaping fix already present in `030b7fa`. |
| `e70150d` | active | Reapplies fifc bindings when `fish_key_bindings` changes, fixing binding persistence across fish keymap changes. |
| `06895ff` | merge-only | Merge of the same directory-option preservation already present in `d7a44c1`. |
| `051febd` | active | Fixes the variable name so configured custom `fzf` options are actually passed through. |
| `caf694e` | active | Fixes file/directory display when the current path contains spaces, avoiding full-path output where short names are expected. |
| `b3f5886` | active | Fixes completion for directory names containing `'`, preventing unbalanced-quote failures. |

### `thalesmello/fifc`

Net effect:
- Independent UX/completion stack, not a bundle of the existing open PRs.
- No exact PR carry from `#36`, `#49`, `#52`, `#54`, `#60`, or `#61`.

Commit-by-commit:

| Commit | Status | Summary |
| --- | --- | --- |
| `d74393b` | active | Wraps the default-source preview window so long preview lines do not require horizontal scrolling. |
| `0861074` | active | Makes opening a selected man-page option jump directly to the correct line instead of using less reliable regex searching. |
| `2c99638` | active | Limits searches rooted at `$HOME` to depth 1, reducing recursion and result volume for home-directory completion. |
| `6f1096c` | active | Changes the interaction model: single-select picker, `Tab` / `Shift-Tab` move selection, per-group history files, and `fd --no-ignore` for file search. |
| `8910243` | active | Improves file completion for incomplete path strings and tightens directory detection and plain-style file previews. |

### `schmas/fifc`

Net effect:
- Largest fork-only UX redesign of the three.
- Final branch keeps hidden-file support, case-insensitive mode, depth controls, new preview behavior, and fzf keybinding changes.
- Approximate overlap with PR `#52` and PR `#54`, but not exact carries.

Commit-by-commit:

| Commit | Status | Summary |
| --- | --- | --- |
| `1b165ac` | active | Adds `fifc_show_hidden=true` support and also preserves existing directory search options, which approximately covers PR `#52`. |
| `ac913da` | superseded | Adds hidden-last sorting for file output; later sorting changes replace this implementation. |
| `9708c44` | superseded | Simplifies the hidden-last sort pipeline; later commits replace this behavior again. |
| `e5d7b00` | reverted | Adds an interactive git branch selector and preview UI. |
| `f75c2ca` | revert/net-zero | Removes the git branch selector again, leaving no net git-branch feature in the final fork. |
| `0ca852d` | active | Adds optional case-insensitive `fzf` matching controlled by `fifc_case_insensitive`. |
| `8773786` | docs-only | Documents the new case-insensitive setting. |
| `e7299b8` | docs-only | Adds project architecture, workflow, and Claude-related documentation. |
| `e49b075` | active/partial | Keeps the keybinding part of the change: `Tab` / `Shift-Tab` navigation and configurable multiselect key; the early directory-sorting part is later revised. |
| `af3205e` | chore | Adds `.gitignore` entries for local planning artifacts. |
| `b32a63c` | superseded | Reworks depth sorting using `awk`; later depth and sorting commits replace the resulting behavior. |
| `db3a0c6` | active | Makes multiselect toggle the current item without automatically moving to the next one. |
| `86edc2a` | superseded | Fixes ANSI handling for the hidden/depth sort pipeline that later disappears from the final branch. |
| `1c6d080` | active/partial | Keeps the vertical directory preview and `eza`-first behavior; the initial `--scheme=path` ranking tweak is revised later. |
| `e054580` | active | Removes `--scheme=path` so shallow boundary matches rank more naturally. |
| `2429282` | superseded | Adds `--no-sort` to preserve source depth order; later removed when alphabetical/natural ordering is restored. |
| `58408e8` | active | Adds interactive search-depth control with `alt-up` / `alt-down` and default depth-limited traversal. |
| `f8f31bc` | active | Adds `ctrl-j` / `ctrl-k` and `alt-1..9` depth shortcuts. |
| `2b98131` | active | Fixes the `alt-1..9` bindings and restores alphabetical/natural ordering instead of the earlier custom sort pipeline. |
| `4b305f1` | active | Clears path-prefix query text when completing inside a typed directory path, improving matching for nested directory completions. |

## Practical merge notes

If the goal is to build a personal fork with the highest-value low-overlap changes:

1. Start with the independent open PRs: `#36`, `#52`, `#54`, `#60`.
2. Choose `#49` or `#61`, not both; `#61` is redundant if you already take `#49` or `justbispo/fifc`.
3. `adam01110/fifc` now also includes the `justbispo/fifc` apostrophe-safe completion fix (`b3f5886`), in addition to the earlier binding-persistence fix (`e70150d`) and paths-with-spaces display fix (`caf694e`).
4. Treat `thalesmello/fifc` and `schmas/fifc` as UX forks, not straightforward PR bundles; several of their changes alter navigation, ranking, preview style, or default search scope.

## Bottom line

- `adam01110/fifc` now carries exact PR `#49`, `#52`, `#54`, and `#60` behavior in one fork, plus the fork-only binding-persistence, path-with-spaces display, and apostrophe-safe completion fixes from `justbispo/fifc`.
- `justbispo/fifc` is no longer uniquely ahead on the apostrophe-safe completion fix; its remaining distinction is the same broader PR bundle plus its own branch history.
- PR `#36` is still unique and would need to be merged separately.
- `thalesmello/fifc` and `schmas/fifc` are best mined selectively rather than merged wholesale.
