# Pulling data

How the data for a piece of research is chosen and pulled. It fills `Data in` on the method card (step 0 of
`method.md`). Written 2026-11-11.

**Supported source: Azul only.** Every pull today is from Azul's Snowflake, following `ds/data/azul.md`. Data from
anywhere else: stop and ask the user before writing a query. A new source gets its own `ds/data/<source>.md` first.

## 1. Ask, one question at a time

Before any query, ask the user these questions **one at a time**: ask one, wait for the answer, write it on the
card, then ask the next. Never send the list. Offer the usual options so a short answer is enough, and skip a
question only when the card or the user already answered it.

The user's questions (2026-11-11):

1. **Dates.** Which departure dates for modelling (fitting), and which for testing? The two do not overlap; testing
   comes after modelling.
2. **Future dates.** Which departure dates still ahead get recommendations? (A method that recommends must show
   future ones: `method.md` step 6.)
3. **ND markets.** All, domestic only, international only, or a list you name?
4. **Passengers.** Revenue passengers only, or all passengers? (Load factor always counts every seat held: see
   `azul.md`. This answer shapes fares, revenue and demand counts.)
5. **Main target.** Load factor or revenue?

Proposed by Claude, waiting for the user's OK (2026-11-11):

6. **Grain.** One row per what: flight leg, segment, or true O&D, by departure date? And by days before departure
   (a booking curve), or only the final value?
7. **Cabin.** Economy only, business only, or both?
8. **Exclusions.** Beyond the standard ones in `azul.md`: groups (10 or more per PNR), flights with an aircraft
   swap, holiday periods, anything else?

## 2. Then pull

- **Show the query before running it,** with the answers it encodes. Run it only on the user's OK.
- **Lean.** Only the columns the answers need, aggregated in Snowflake.
- **Parameters, not literals.** Dates, markets, passenger filter and target are inputs to the pull script.
- **Pull once, save, reuse.** Save to disk with a metadata file: pull date, the query as run, the answers above,
  row counts. Every method on the task reads the same saved pull. Pull again only when the user asks, or when the
  question's scope changes (a leg pull cannot answer a network question).
- **Name the pull date** in every deliverable.
- **Data that cannot leave the machine stays out of git.** No credentials in any file.

## Open issues

- Point-in-time pulls (rebuilding what was known N days before departure): out of scope for now, the user's call
  (2026-11-11). Don't ask about it.
- Whether a data role owns pulls instead of the researcher (`ds/notes/data_sourcing.md`, section 3).
- Where saved pulls live (repo, shared drive, Snowflake), already open in `CLAUDE.md`.
