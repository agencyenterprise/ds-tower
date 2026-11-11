# The method standard

How research is conducted here: the agreement every researcher follows and the evaluator checks against. The
methodologist keeps it; every change is a pull request on the fork, approved by the user.

Each step leaves a file, so a reread brings the idea back in full.

0. **Clear before starting.** No research starts until the idea is steelmanned, its result is mocked up and agreed,
   and four things are agreed with the user and written on the method card (`## Before starting`). Missing any one:
   the work waits.

   a. **Steelman the idea, a lot.** On the card, under `## Steelman`:
      - The idea in its strongest form, so its author would sign it.
      - The strongest case against it, and the strongest rival idea that would answer the same question.
      - What would make it fail: the result that would kill it.
      - Each objection answered, or kept as an open issue.

      Go round with the user until neither of you finds a new objection.

   b. **Mock the result until you both agree.** Before any real data is pulled, show the user what the finished
      research would look like, made of fabricated data: the plots, the tables, the labeled examples, the
      one-line answer. The user corrects it, the researcher redraws it, and this repeats until both agree: "this is
      the research we are about to conduct". Then the user's agreement and its date go on the card under
      `## Mock-up`, with links to the mock files.
      - Every mock plot and table is titled `MOCK: fabricated data`. A mock number never appears in a result.
      - The mock shows every kind of outcome (for a price call: increase, decrease and keep) and the case with no
        answer.
      - A change of mind in the mock is cheap. A change of mind after the data is pulled is not. Spend the rounds
        here.
      - The agreed mock fixes the four items below. Later real results are drawn the same way, so the user can
        compare them with the mock.

   The four items, taken from the agreed mock:

   1. **Data in:** the data the analysis reads: source, population, grain, the snapshot it runs on. Chosen with the user one question at a time and pulled as `data-pull.md` says (Azul
      data only, for now).
   2. **Reference and comparison:** which reference data is used, if any, and exactly how the comparison is made.
      Every method on the same task uses the same comparison, otherwise no one can tell which method works.
   3. **The story:** what the work has to explain, told at a very high level without technical details, so the
      storyteller can tell it from the first day and keep it updated as results come in.
   4. **Evaluation:** how results will be judged, and labeled examples of each kind of thing the method must spot
      (for a price call: increase, decrease and keep). Examples may be fabricated when real ones are not at hand,
      and are marked as such. Without a way to evaluate, there is no research.
1. **Hunch.** Write the idea down with what would change if it were true, and keep it (`tower keep hunches`, from
   `hunch.md`). It joins the idea queue (`queue.md`).
2. **One researcher, one idea.** A researcher explores the one idea in their brief. A new idea found on the way
   becomes a hunch for another researcher, never extra scope.
3. **Smallest test, registered first.** Before running anything, one line on the method card: the smallest test of
   the idea and the result that would count as worked or failed.
4. **A comparison, always.** Judge the new method against the current one (the baseline) on the same inputs, never
   on its own. No baseline yet: building one is the first test.
5. **Two hypotheses per finding.** Next to each finding, the strongest other explanation and the check that would
   tell them apart.
6. **Recommendations look ahead.** A method that recommends shows recommendations for dates still ahead, made with
   only the data known on the pull date. Past recommendations (backtests) are evidence, not the deliverable: a
   result with past ones only is not complete.
7. **Report with numbers.** What was done, what came out (with numbers), what it means, what is uncertain or not
   verified, and the next step.
8. **Failed is useful.** Say what it rules out. Separate the idea from the specific test before dropping the idea,
   and propose a different small step. Worked: the next step may be bigger in the same direction, still one at a
   time.
9. **Evaluated before it counts.** A result is final only when the evaluator has checked it against this standard
   and written `passed` on its card.
10. **Standard when reviewed.** A method joins the team's standard when its card holds the baseline comparison, it
   reruns from data and code in the repo, and another team member has reviewed it on its thread.
