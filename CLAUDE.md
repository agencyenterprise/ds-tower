@PRINCIPLES.md
@AGENTS.md

# ds-tower

A research tool for exploring data science ideas, built on the tower. Its subject is **method creation**: how the
team takes a hunch to a method others can trust and reuse, and one standard way of doing it across the team.

The two files imported above are upstream's and describe the tower itself. Everything below is this fork's, and
holds for DS research work done here. Where the two meet (code in this repo), `PRINCIPLES.md` wins.

## The fork

- `origin` is the fork, `agencyenterprise/ds-tower`. `upstream` is the tower, `RegiByte/the-tower`. A fresh clone
  adds it once: `git remote add upstream https://github.com/RegiByte/the-tower.git`.
- **The core stays identical to upstream.** DS work goes only in the fork's own paths (Layout, below), so a sync is
  a merge with no conflicts. Never edit `PRINCIPLES.md`, `AGENTS.md`, `CHANGELOG.md`, `src/`, `renderers/` or
  `extensions/` here. A core change the team needs goes upstream as a pull request, and arrives here by the next
  sync.
- `CLAUDE.md` is the one file both sides touch. On a sync conflict, keep upstream's import lines at the top and this
  fork's section below them.
- Sync before starting new work, on a branch only when `main` has commits of its own:

  ```bash
  git fetch upstream
  git merge --ff-only upstream/main   # while main has no fork commits; otherwise: git merge upstream/main
  git push origin main
  ```

- After a sync: `npm ci`, then `tower doctor`. A sync that crosses a release flagged **host restart** in
  `CHANGELOG.md` kills running sessions when the host restarts (they can be resumed).
- Last sync: 2026-11-10, fork moved from v1.107.0 to v1.109.0 (fast-forward, 43 commits).

## Layout

The tower's own model, used for research: `Extension before core` and collections as files kept for later. Details
and setup: `ds/README.md`.

- `ds/roles/<role>.md`: one job description per role, linked into each floor's `roles.prompts` collection by
  `ds/link-roles.sh`. Upstream's `examples/extensions/roles` does the rest (model per role, prompt, who may hire);
  nothing of it is copied or changed here.
- `ds/standard/method.md`: the method standard, the ways of working every role follows. Templates for a hunch and a
  method card beside it.
- `ds/standard/data-pull.md` and `ds/data/<source>.md`: how data is chosen and pulled. Azul is the only source
  supported (2026-11-11); its tables and the correct load factor and fare paid are in `ds/data/azul.md`.
- `ds/config.example.json`: the collections (`hunches`, `methods`, `decisions`, `stories`) and the `roles` settings
  every team member adds to their own config, so floors look the same across the team.
- `ds/extensions/<id>/`: the fork's own extensions, when one is needed (none yet).

## The research team (the user's instructions, 2026-11-10)

- The tower is used for research, by a team of roles. Each role's job description is its own file in `ds/roles/`,
  so it can evolve. Roles will be added, removed and their responsibilities changed: do it by editing those files and
  the `roles` settings, never by hard-coding a role anywhere else.
- The user sets each role's instructions. Drafts written by Claude are starting points the user rewrites; don't
  change a role file without being asked. The files are shared with the rest of the team through the fork.
- **Researcher:** explores one idea, and only one. It may suggest improvements, but a new idea is kept as a hunch and
  picked up by another researcher.
- **Methodologist:** sets the ways of working, how research is actually conducted and the rules to follow
  (`ds/standard/`).
- **Evaluator:** makes sure the final results respect that agreement.
- **Storyteller:** tells the story of what is going on in a user-friendly way (slides, for instance).
- **Decisions:** exposes to the user the decisions made that the user should be aware of.
- **The idea queue** (2026-11-10): ideas waiting to be executed live in the `hunches` collection, one file each with
  a status (`ds/standard/queue.md`). Spinning up researchers for queued ideas is the next piece of work, parked for
  now: the user starts each researcher by hand until then.

## The method standard

Lives in `ds/standard/method.md`. Read it before any research work; change it only by a pull request the user
approves.

## Working here

- Build on what exists: read the code or method that already does part of the job before writing new, and say what
  a change could break downstream.
- Findings, decisions and open issues go into a file in the project (a method card, a hunch, a review thread), not
  only into chat.
- No credentials in the config or in any kept file (`PRINCIPLES.md`, `no-credentials`). Data that cannot leave the
  machine stays out of git.
- No em dashes or en dashes in anything written here.

## Open issues

- What a "method" covers: a modelling technique, an analysis recipe, an evaluation protocol, or all three. The
  method card's fields depend on it.
- Where datasets and results live: in the repo, on a shared drive, or in Snowflake, and what is safe to commit.
- Whether the standard should be enforced (a policy or check that refuses a method card without a baseline) or only
  taught (a skill workers read).
- Spinning agents for new ideas (parked 2026-11-10): who takes the next queued idea and starts its researcher. Today
  the user does it by hand: no role hires. Candidates: a coordinator role that hires, a tower policy that runs on a
  slot, or an extension. The queue's status lives inside each file, so `tower kept hunches` does not show it yet.
- Research floors that are not this repo read `ds/standard/` by its path in the ds-tower checkout. Whether the
  standard should also be a collection or a skill, so it reaches any floor, is open.
