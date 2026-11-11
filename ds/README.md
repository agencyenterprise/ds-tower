# ds: the research team

The fork's own files. The tower runs a research team of roles; each role's job description is one file here, so
roles can be added, removed and changed by editing files, and the whole team pulls the same ones.

## What is here

| Path | What it is |
|---|---|
| `roles/<role>.md` | One job description per role. It joins the system prompt of every worker in that role. The user writes and owns these. |
| `standard/method.md` | The ways of working: how research is conducted, the agreement the evaluator checks. Kept by the methodologist, changed only by a reviewed pull request. |
| `standard/data-pull.md` | How data is chosen (intake questions, one at a time) and pulled. Azul data only, for now. |
| `data/azul.md` | Azul's tables, and how to read load factor and fare paid correctly, from the azul-worker repo. |
| `standard/core-values.md` | The AE core values in short, and what each looks like on this floor. Every role follows them; the director checks them. |
| `standard/queue.md` | The idea queue: how ideas wait in `hunches`, in what order, and how one is taken and closed. |
| `standard/hunch.md`, `standard/method-card.md` | Templates for a hunch (an item in the queue) and a method card. |
| `config.example.json` | The collections and the `roles` extension settings to add to your `~/.tower/config.json`. |
| `link-roles.sh` | Points a floor's `roles.prompts` collection at `roles/`, so workers read the files in git. |

## The roles (first version, 2026-11-10)

| Role | Does | Hires | Consulted |
|---|---|---|---|
| `researcher` | Explores one idea, only one. New ideas become hunches for another researcher. | no | no |
| `methodologist` | Keeps the ways of working; answers how to apply them; proposes changes as PRs. | no | yes |
| `evaluator` | Checks a final result against the agreement, rule by rule; writes the verdict on the card. | no | no |
| `storyteller` | Tells what is going on in plain words, usually a slide deck, from the files only. | no | no |
| `decisions` | Lists the decisions made that the user should know about, unseen ones first. | no | no |
| `director` | Makes sure every role lives the core values (`standard/core-values.md`); proposes role changes as PRs. | no | yes |

No role hires: the user starts every worker. Model per role is in `config.example.json`.

## Set it up (once per machine)

1. Copy the `collections` and `extensions.roles` entries of `config.example.json` into `~/.tower/config.json`, with
   `path` set to your checkout's `examples/extensions/roles`.
2. Link the job descriptions for each floor that does research: `ds/link-roles.sh <project>`.
3. Start a worker with a role: pick it in the spawn form's Role field.

## Change a role

- Edit its file in `roles/`: the next worker started or resumed in that role reads the new version.
- Add a role: a new `roles/<name>.md`, plus an entry under `extensions.roles.settings.roles` in your config and in
  `config.example.json`.
- Remove a role: delete both. A worker already in it keeps running, without its prompt on resume.
- Commit the change on a branch and open a PR on the fork, so the team gets it.

## Checked

2026-11-10, on the sandbox: a spawn in role `researcher` launched with `researcher.md` in its system prompt and
`--model opus`; the same spawn with no role had no role prompt; a researcher's hire was refused by the roles gate.
Not checked: a real Claude session following the prompts.
