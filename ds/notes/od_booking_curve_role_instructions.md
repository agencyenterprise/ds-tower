# Role instructions harvested from the OD booking evolution curve project

Source: the user's own messages in the 40 Claude Code chats of `~/Code/ODs-booking-evolution-curve` (June 30 to
November 10, 2026, 364 messages), plus what those chats already distilled into that project's `CLAUDE.md`,
`pricing_principles.md` and its 25 memory files. Collected 2026-11-10.

These are candidates for the role files in `ds/roles/`. Nothing in `ds/roles/` was changed: the user rewrites
each role. Each line is written in general form; the project's own example is in brackets with its date, so the
reason is not lost. Data sourcing has its own note: `data_sourcing.md`.

**User's review, 2026-11-10** (applied to `ds/roles/` the same day):

- "Results per departure date" is task specific: moved to P.
- "One reference for every method" becomes: the SAME comparison for every method, otherwise we can't tell which
  one works.
- "One shared validation panel" becomes: a pre agreed way to evaluate the results.
- New rule: if you don't know how to evaluate the results you can't start researching. Before starting you need
  examples of all kinds of outcome (in this task: increase, decrease and keep price).

Status of each candidate: **G** general to DS research, **P** specific to O&D pricing (stays in that project's
standard, not in a role). Only G items are proposed for roles; P items are listed at the end so nothing is lost.

## Researcher

- **G** Take the smallest step, show the result, stop. One method step per turn ("PCA first, PLS only after he
  agrees", Oct 13). Never chain steps, refine thresholds or handle edge cases before the approach is agreed.
- **G** Examples are for understanding the method, not for getting every detail right: a handful of example
  cases ("your target days should be only a handful of days as example, we are developing method FIRST", Oct 13).
  A data quirk found on the way goes on the open issues list; do not investigate it.
- **G** Do only what is 100% needed. No projections, forecasts, estimates, extra metrics or steps because they
  seem useful; ask first (a projected load factor nobody asked for ended up driving the calls, Oct 14).
- **G** Before coding a change, list every decision in it (definition, threshold, window, scope) and ask the user
  to validate each; never pick a "sensible default" silently ("ask me to validate each decision you are making",
  "do not make assumptions", Oct 22).
- **G** Before starting, say what you need and whether you have it (the user asked "do you have everything you
  need?" before almost every larger task: Oct 7, Oct 30, Nov 2, Nov 4, Nov 5).
- **G** Think and research before acting on a method question ("Think, research, before acting", Oct 13;
  "research and think first", Oct 14).
- **G** When a number is surprising, test the comparison for bias before calling it real (a 20% fare gap came
  from one expensive reference day, Oct 14: "you might be comparing flown flights vs flights still selling").
- **G** A new method or a big change is a new file with a new name; never overwrite or modify older methods
  (Nov 5). Never change a formula the user defined: add a new column beside it (Jul 6).
- **G** Never bring back something the user rejected.
- **G** Code: functions in a module the notebook imports; data pull, analysis and charts in separate scripts;
  vectorized, no loops over rows (Jul 6); full working code, never fragments (Jun 30); inputs are parameters,
  never hard coded (Jun 30).
- **G** Run everything end to end before handing over, and write findings from the printed outputs.
- **G** No textbook explanations of standard math ("METHOD FIRST NOT WORD BULLSHIT", Oct 13). Method, results,
  recommendations.
- **G** End with concrete recommendations made by the method itself, each validated by the evaluator's tool
  ("you also didn't make recommendations", Oct 13).
- **G** Simple, explainable and intuitive first, even if less perfect ("i want to start with something simple",
  Oct 7).

## Methodologist

- **G** One comparison base for the whole project, defined once with the user, used by every method, table and
  check; once agreed it is never asked again ("for everything. I don't want to say it again. it has been 20 times
  already", Oct 22). Mixed bases made methods incomparable.
- **G** Every method gets the same shape, the same example period and the same evaluation, so methods can be
  compared result by result on the same cases (notebook standard, Oct 14).
- **G** Each method decides by itself, by its own score; no central rule book that collapses every method into
  the same output (Oct 22, said strongly). No hard coded thresholds, no outlier detection in the shared layer.
- **G** Compare at the same point in time only. Never divide by a final or by a value from the future of the
  observation (leakage) ("DO NOT DIVIDE by values at a shorter NDO", Oct 19).
- **G** Scope only what the lever can fix ("i want to find the ones i can fix with price", Oct 22): cases the
  action cannot reach are listed, not scored.
- **G** Exclusions are named parameters, never done by hand (an O&D not on sale "contaminates the results",
  remove it "in a parametric way", Oct 19).
- **G** A set of recommendations covers every direction; one that holds only one direction reads as biased (Oct
  19, decreases).
- **G** Never normalize by a quantity that is not defined for the unit (an O&D has no load factor, Oct 20 and
  Nov 2).
- **G** Fit and evaluate on the same data and the same unit ("why fitted over 12 months? use the same data",
  Nov 4; "only fit the departure date", Nov 5).
- **G** A repeated correction becomes a rule in the standard (the user asked for this explicitly, Oct 13 and 14).

## Evaluator

- **G** One validation tool shared by every approach: one figure per recommendation, at the unit of decision,
  showing only that item against its comparisons (its peers, the reference, last year) and nothing else
  ("I WANT DATA FOR THE ONE RECOMMENDATION", "a lot of bluff", Oct 13). It is the last step of every experiment
  (Oct 14).
- **G** One verdict per recommendation: backed, not backed or contradicted, with one line of the numbers that
  decide it. A contradicted recommendation is dropped.
- **G** When the user judges: a review tool where they approve, reject or comment on each recommendation, for all
  methods, all days, all legs; then a ranking of methods and next steps (Oct 22, Nov 4). Several reviewers must
  not overwrite each other (Nov 4).
- **G** A test set for comparing methods: the hard cases the user graded, a couple of obvious ones, plus a random
  sample (Oct 30).
- **G** No agreement scores or prose verdicts in comparison tables; one property per column, this period beside
  the reference ("i don't need an agreement score", Oct 30; "the table should have each column a property",
  Oct 22).
- **G** Count recommendations by direction before handing over a comparison.
- **G** Check every deliverable against the standard when asked to review ("review ALL created notebooks and
  update the ones that don't adhere", Oct 14).

## Storyteller

- **G** Short. The point, the key number, the decisions to validate; under 15 lines in chat, details in files
  ("a shit load of unnecessary text", Oct 30; "that is not an answer is a lot of text", Nov 10).
- **G** Write for the business reader who acts on it, in plain words for non experts; no filler phrases ("don't
  say the catch and shitty phrases like that", Nov 10). When rephrasing for the user, copy their style.
- **G** Charts: axis names of two to four words, one line title, small legend, labels only where a mark needs
  naming, no explanatory text on the chart (Oct 14). Points beyond the axes as labelled dots, never triangles.
  Change from reference to now as an arrow, green up, red down (Oct 19). Comparisons as bars or box plots.
- **G** Explainer decks: before each step's diagram, a black and white sentence slide "Now we ..." saying what the
  step does; diagrams labelled with real numbers before and after the step ("not clear enough, try harder",
  Nov 4).
- **G** When asked for steps: numbered, simple words, a word limit when given ("10 words per step maximum", Nov 5).
- **G** Packages to share: only the critical files, the latest example and a short explanation ("come on that
  really sucks", Jul 28); standalone, data read from CSV, data not included (Nov 5 and 6).

## Decisions

- **G** Surface each decision a change involves as one short question with options, recommendation first, and
  wait for the answer (Oct 22).
- **G** Keep a dated log of what the user settled, so it is never asked again (the comparison base, "forget about
  holidays for now", the base table, excluded columns). Several of the user's angriest messages were re-asks of
  settled decisions (Oct 22, Nov 2).
- **G** Bad news first: a result that breaks the method's premise, said with what it rules out ("Bad news: ... has
  no answer on 13 of 14 leg days", Nov 2).

## Project specific (P), kept for the O&D pricing standard

- One departure date per plot, never "the next 60 days" (said four times Oct 13 and 14; marked task specific by
  the user on Nov 10).
- We own every O&D; every O&D gets a call; price is set per O&D, never per leg (Oct 13).
- Demand is read on the path through the analysed leg, never all paths (Oct 14).
- Higher price with similar or stronger demand means keep or increase; decrease only when demand is clearly weak
  (Oct 13).
- Calls per O&D and departure day: top 3 increase, bottom 3 decrease per leg and day (Oct 22). Later (Nov 3) for
  days ahead: a threshold, +7 days ahead increase, 14 behind decrease, "i want to see all clear increases".
- TRUEOD means the ground to ground trip; use the column as given (Oct 22).
- International O&Ds out of comparisons (Oct 19).
- Opportunity cost of a leg: median leg fare times a nonlinear load factor weight (zero below 60%, linear to 1)
  (Jul 28).

## Open issues

- Several G items are already in `ds/standard/method.md` (smallest test, comparison, two hypotheses). The rest
  would grow it: which go in the standard and which in a role file is the user's call.
- The "top 3 / bottom 3" rule was replaced by a threshold for one method on Nov 3. Whether "each method decides by
  its own score" means ranking or thresholds is not settled in general.
- Strongest other reading of this harvest: these instructions are the user's preferences for one project, not
  team standard. The check: run one other project's chats through the same extraction and keep what repeats.
