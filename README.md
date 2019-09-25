# graph-theory
Graph-theoretic operations in Factor

# Installation

## Adding vocabulary search paths

By default, Factor loads vocabularies from the `<path-to-factor-source>/work/` folder.  As an example, if you cloned the Factor repo into `~/Downloads/factor` and built it there, your `work` folder will be at `~/Downloads/factor/work`.

If you want to load vocabularies from somewhere else, you do so by modifying your "vocabulary roots", which amounts to the same thing as a `PYTHONPATH` in Python.  To add a vocabulary root, create a `.factor-roots` file in your home directory (`~`) and add additional roots, one line per path.

Then, quit Factor, reopen it, and use `vocab-roots get` to print the list of vocabulary roots; the last string(s) in the list should be the one(s) you just added (the previous ones, prefixed with `resource:` are enabled by default and evaluated relative to the Factor source folder).

See docs:
- https://docs.factorcode.org/content/article-vocabs.roots.html
- https://docs.factorcode.org/content/article-.factor-roots.html

Example setup:

I have Factor installed to `/nix/store/<...factor...>/`.  I want to load Factor vocabularies from `~/hacks/factor-projects/work`.  I put the following in `~/.factor-roots`:

```
~/hacks/factor-projects/work
```

This is the output of `vocab-roots get`:

```
IN: scratchpad vocab-roots get .
V{
    "resource:core"
    "resource:basis"
    "resource:extra"
    "resource:work"
    "~/hacks/factor-projects/work"
}
```

## Folder layout

Each vocabulary is located under its own folder.  Here, we have a root-level `graph-theory` vocabulary and also have, say, `graph-theory.weighted` and `graph-theory.unweighted`.  Here's how we lay that out:

- `<vocab root that we want to use>/`
  - `graph-theory/`
    - `graph-theory.factor` (contains a `IN: graph-theory`; all `graph-theory.*` words defined here)
    - `weighted/`
      - `weighted.factor` (`IN: graph-theory.weighted`)
    - `unweighted/`
      - `unweighted.factor` (`IN: graph-theory.unweighted`)

We add tests for a vocabulary by adding a `<vocab-name>-tests.factor`, and add docs inside a `<vocab-name>-docs.factor`; both such files are located in the same `<vocab-name>/` folder.

Docs:
- https://docs.factorcode.org/content/article-vocabs.loader.html
