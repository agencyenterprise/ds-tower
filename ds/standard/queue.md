# The idea queue

Ideas waiting to be explored. The queue is the floor's `hunches` collection: one file per idea, from `hunch.md`.

## Rules

- **Adding.** Anyone adds an idea with `tower keep hunches` (a worker) or by saving a file in the collection (the
  user). It starts as `Status: queued`. A researcher's new idea goes here too, never into its own work.
- **Order.** `high` priority first, then oldest first. Item ids start with the moment they were kept, so
  `tower kept hunches` lists them oldest first.
- **Taking.** One idea goes to one researcher. When a researcher is started on it, its status becomes `taken` and
  `Taken by` names the researcher. An idea is never taken twice.
- **Closing.** `done` when its method card reaches a verdict (passed or dropped), naming the card. `dropped` when the
  user sets it aside, with one line on why.
- **Deleting.** Never: a dropped idea is a record of what was not tried and why.

## Not built yet (parked 2026-11-10)

Starting a researcher from the queue. Today the user reads the queue and starts each researcher by hand, with the
hunch as its brief. Who takes the next idea, and whether the tower does it on its own (a policy, a coordinator role,
or an extension), is open.
