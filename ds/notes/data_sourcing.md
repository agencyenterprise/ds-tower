# Data sourcing: every instruction, and how to generalize it

Which data to pull and what to compare it against decide most DS results. This note collects every data sourcing
instruction the user gave in the OD booking evolution curve project (40 chats, June 30 to November 10, 2026), then
proposes the general shape of a separate data process. Collected 2026-11-10. Companion of
`od_booking_curve_role_instructions.md`.

## 1. The instructions, as given

Grouped by the question each answers. Dates are when the user said it.

### Source

- One base table for the whole project, chosen by the user: `SANDBOX_AE.AE_STUDIO.AE_MANIFESTS` ("USE AE MANIFESTS
  as the base table", Oct 7). Do not switch to other tables; suggest one only when the base truly lacks the
  information, and ask first.
- How the table is built and queried lives in another repo (`azul-worker`: its `CLAUDE.md`, skills, SQL builders).
  Check there before guessing how a column is derived (Oct 7).
- Known properties of the source, measured: rebuilt daily from 45 days back with each booking's current state, so
  last year "at the same point" carries a survivor bias (about 1%, measured Oct 14); today's bookings are partial,
  so they are left out on both sides of a comparison.
- Credentials outside the repo; Snowflake read only; dates cast to strings for the MCP tool.

### Pulling

- Show the query before running it ("share the query you are planning to use. you are pulling too much data we
  don't care about", Oct 7; "show me the sql before implementing", Jul 6).
- Pull lean: only the columns needed, aggregated in Snowflake.
- Columns never used: `TRIP_PURPOSE`, loyalty tier, cabin (Oct 7).
- Inputs are parameters (leg, direction, dates), never hard coded ("why this is not parametrized", Jun 30).
- Pull once, save to disk with a metadata file, load from disk; experiments reuse the saved pull ("create viz in a
  python script and the data pulling in a data script, save data to disk", Oct 7).
- Do not pull new data unless asked ("don't need to pull more data, you can use the old one. put that in the
  project instructions", Oct 13; repeated Oct 15, Oct 21, Nov 2). No query inside a notebook; never `force=True`.
- Every method runs on the same pulled data ("run all methods on same pulled data", Oct 30).
- The pull date is named in every deliverable; the example period is set relative to it.
- When the question changes scope, the pull must change too: a leg filtered pull cannot answer a network question
  ("YOU NEED TO PULL DATA AGAIN BC YOU ONLY HAVE DATA for people flying a given leg", Oct 22).

### Population (who counts)

- Only units that touch the thing analysed ("there are true od that has no thing to do with my rec-vcp", Jun 30);
  directional; return trips ignored (Jun 30).
- The identity column is used as given, no checks ("TRUE OD MEANS TRUE OD", Oct 22).
- Revenue bookings only for revenue numbers: paid above zero, a revenue fare class, no change reason (Oct 22;
  earlier `FAREPRICE > 100` to drop award tickets, Jul 3). Seats and load factor count everyone.
- Groups (10 or more per PNR) out.
- Unique passenger id; distinct counts.

### Definitions

- Revenue = `FAREPRICE + DYNAMICFAREADJUSTMENT` (Jul 3).
- Selling window NDO 0 to 240 (Jul 3).
- A leg's fare is the median over all its passengers, not only the O&D's (Jul 3); kept as two columns, same O&D
  and all O&Ds (Jul 10).
- Shares that describe a segment are computed at segment level from one year of history, same value on every
  flight; the flight level column kept beside it (Jul 7).
- Booking fractions by window are cumulative (0 to 7, 0 to 14, 0 to 28, 0 to 60) (Jul 7, said with emphasis).
- An O&D with several itineraries: average over them, never the sum (Jul 1).
- Origin and destination: seats departing the origin on the departure date, seats arriving at the destination on
  the arrival date; only passengers whose trip starts or ends there, never those connecting through (Oct 21).

### Grain

- One row per unit of decision (O&D by departure date), context columns repeated on each row (master dataframe,
  Jun 30).
- Fit on the decision unit too: "only fit the departure date. ONLY one date x segment, all ODs" (Nov 5).

### Comparison (how to compare)

- One reference for everything: last year = the 6 same weekdays at 3, 2, 1 weeks before and after the day 364
  back, anchor out, averaged (Oct 22). It went through: single same weekday (too noisy), same weekday in last
  year's month (Oct 14), then the 6 day standard. No holiday handling for now.
- Same point in time only: compare at the same NDO; never divide by a final or a later value (Oct 19).
- Peers at the same point: same segment and weekday, same segment and month, all flights of the leg (Oct 19).
- More time depth for structure: the same O&D 7 and 30 days before (Oct 19).
- A comparison group beside the unit: the locals, and the whole leg (Oct 19, Oct 22).
- No normalizer that is undefined for the unit (no O&D load factor, Nov 2).

### Exclusions (parameters, not by hand)

- Not offered: nothing booked this year while last year had bookings at the same point (Oct 19).
- Not selling now: no revenue booking in the last 7 days (Nov 2), later 30 days for a call (Nov 3).
- Too thin: fewer than 2 passengers booked (Oct 23).
- Out of scope markets: international destinations (Oct 19).

### Sharing data

- Standalone packages read data from CSV and ship without the data (Nov 5 and 6).

## 2. What generalizes

Most of the list is one of six questions every DS task answers, whatever the domain:

1. **Source.** Which table, who decided, where its build logic is documented, its known biases (measured, with
   numbers).
2. **Snapshot.** The as of date, the query as run, the file it was saved to. Pulled once, shown before it runs,
   reused by every method.
3. **Population.** Who counts, as named filters (revenue only, groups out, directional, touches the unit).
4. **Definitions.** Each measure written once (revenue, fare, cumulative fractions, aggregation over duplicates).
5. **Grain.** The unit of decision, the row of the table, and the unit models are fit on.
6. **Comparison.** The reference (one, for everything), the point in time rule (no leakage), the peer groups,
   and the exclusions as parameters.

Questions 1 to 5 are "which data to pull"; question 6 is "how to compare". The user's strongest corrections were
on 6 (the reference, same NDO) and on re-asking settled answers to 1 and 3.

## 3. Proposed shape (for the user to decide)

- **A data card per project**, kept in a collection (for example `datasets`), with the six sections above. It is
  written with the user before the first pull and changed only by them. Every researcher and the evaluator read
  it; the methodologist checks that methods use its reference and exclusions.
- **A pull card per snapshot**: as of date, query, file, row counts, which data card version it follows.
- **A data role** (name open: data steward, sourcer) that owns pulls: shows the query first, pulls lean, saves the
  snapshot, records its card. Researchers do not pull; they ask for a pull, which is how "do not pull new data"
  becomes structural instead of a rule repeated five times.

## Open issues

- Whether the data role writes SQL or only the spec that a project's own code turns into a query.
- Where snapshots live (already open in `CLAUDE.md`: repo, shared drive or Snowflake).
- Which definitions are team wide (point in time rule, exclusions as parameters) and which stay per project
  (revenue formula, the 6 day reference).
- Strongest other reading: the comparison rules are the method itself, not data sourcing, and belong to the
  methodologist. The check: in a second project, see whether the reference changes with the method (then it is
  method) or stays fixed across methods (then it is data, as here).
