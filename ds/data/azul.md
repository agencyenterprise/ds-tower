# Azul data: where it is and how to read it right

The only data source supported today (`ds/standard/data-pull.md`). Everything here comes from the
`agencyenterprise/azul-worker` repo, which builds the tables; file references are into that repo. Read on
2026-11-11 at commit `14eaa03`. When this file and azul-worker disagree, azul-worker wins: check there and fix this
file.

## 1. Access

- Snowflake, read only. Through the Snowflake MCP tool when the session has it (cast dates to strings), or
  `snowflake-connector-python` the way azul-worker does (`src/app/services/snowflake/connector.py`, lines 161 to
  390). Credentials come from your environment (`SNOWFLAKE_*` variables), never from a file in this repo.
- Warehouse `RM_WH`. The derived tables live in `SANDBOX_AE.AE_STUDIO` (production: read, never write). Raw sources
  are `NAVITAIRE.REZADOD01.*`.
- Snowflake's `CURRENT_DATE()` is Sao Paulo time.

## 2. Which table answers which question

| Question | Table | Grain |
|---|---|---|
| Who flew, what they paid (final state) | `SANDBOX_AE.AE_STUDIO.AE_MANIFESTS_PUBLIC` (view over `AE_MANIFESTS`, adds the all-in fares) | passenger x leg |
| Same, at journey (true O&D) grain | `SANDBOX_AE.AE_STUDIO.AE_OD_MANIFESTS` | passenger x journey |
| Flight level LF, revenue and ND market by days before departure (booking curve) | `SANDBOX_AE.AE_STUDIO.PNL_SYSTEMTIMESERIES_BASE` | flight x capture date x cabin (`NEST`), with `NDO` |
| Market list, domestic or international | `SANDBOX_AE.AE_STUDIO.AE_MARKETS` (`MARKET`, `INTERNATIONAL`) | market |

Point-in-time pulls are out of scope for now (`data-pull.md`, open issues).

## 3. Load factor, the correct way

**Load factor = seats held / LID.** LID is the authorized (sales) capacity; physical capacity is a second column.

- **Seats held:** a row holds a seat if and only if `INVENTORYSEATSTATUS = 'HK'`. `HL` is the waitlist and holds no
  seat (nor do HP, UC, UN, HX, NO). An unpaid hold is a real seat. **Never use `BOOKINGSTATUS` as a seat filter**;
  for paid only, add `BOOKINGSTATUS = 'Confirmed'` on top of HK, never instead of it
  (`.claude/skills/manifest-seat-status`).
- **Count distinct `PASSENGERID` per leg.** About 75 passenger-legs per window appear twice under two segment ids.
- **Everyone counts** in load factor: staff, award, GDS, no-shows (they held the seat), infants are not filtered.
  The passenger answer of the intake changes fares and revenue, not load factor, unless the user asks otherwise.
- **Leg level.** Load factor belongs to a flight leg (`FLIGHT_ID`). A true O&D has no load factor: never normalize
  an O&D by one.
- **Current LF of a flight** in the manifests: `MAX(LOAD_FACTOR)` per `FLIGHT_ID` (it is a running count by booking
  time; the last row is the current value). `LOAD_FACTOR_CAP` is the same over physical capacity.
- **LF by days before departure:** `BOOKED / LID` from `PNL_SYSTEMTIMESERIES_BASE`, with azul-worker's standard filters
  (`src/app/models/full_flights_prediction/queries.py`, lines 52 to 57):

  ```sql
  NEST = 'Y' AND BOOKED >= 1 AND LID > 10 AND COALESCE(BOOKED / LID, 0) >= 0.01
  ```

  Business cabin is `NEST = 'C'`.
- **Aircraft swaps** change LID after the fact (about 24% of legs see a capacity or LID change in the last 14
  days). The manifests use the latest LID. Whether to drop swapped flights is intake question 8.
- **A flight with no seat held is 0%, not missing.**

## 4. Fare paid, the correct way

**Fare actually paid per passenger per leg = `LEG_FINAL_FARE`** (in BRL) from `AE_MANIFESTS_PUBLIC`
(`create_manifest_public.py`, lines 219 to 237):

```sql
LEG_FINAL_FARE = LEG_FAREPRICE - LEG_DISCOUNT
               + DYNAMICFAREADJUSTMENT * FARE_PROPORTION   -- APO price adjustment
               + FARESURCHARGE * FARE_PROPORTION           -- international only
```

- **Do not use bare `NETFARE`.** It leaves out the dynamic price adjustment, and it is set to 0 for GDS, TudoAzul,
  staff and no-shows even when they paid.
- **`FINAL_FARE` is per journey** and repeats on every leg of it. Summing it over legs counts a connection twice:
  use `LEG_FINAL_FARE` per leg, or dedupe on (`PASSENGERID`, `BOOKINGID`, `TRUEOD`) before summing `FINAL_FARE`
  (without it, totals run about 1.4% high).
- A journey's fare is split over its legs by the square root of distance (`FARE_PROPORTION`).
- Not in the fare: taxes, fees, ancillaries (separate columns), points (`FAREPOINTS`, `POINTSCHARGED`, no BRL value
  found). Currency is converted with today's rate, not the rate on the booking date. Refunds and exchanges: only
  deleted charges are removed.
- The O&D project's earlier formula, `FAREPRICE + DYNAMICFAREADJUSTMENT` (2026-07-03), is a journey-level number
  without the discount; check with the user before mixing it with `LEG_FINAL_FARE`.

**Revenue passengers** (azul-worker's standard filter, `create_pax_on_reference_flights_view.py`, lines 48 to 55):

```sql
CHANNEL NOT IN ('AzulViagens', 'TudoAzul', 'GDS')
AND AZULPAX IS NULL                 -- staff and guests (fare classes XP XI ZZ XA ... )
AND NETFARE > 0                     -- drops award and zero fare tickets
AND FARECLASSOFSERVICE != 'GR'      -- groups
AND PAX_TYPE IN ('ADT', 'CHD')      -- children pay the same; infants out
AND CHANGEREASONCODE = ''           -- no reaccommodated passengers
AND SOURCEUSERCODE != 'PortalGrupos'
```

This drops GDS and TudoAzul sales, which do pay: it is a filter for clean fare references, not for total revenue.
Say so when revenue is the target, and ask which the user wants.

## 5. Markets and dates

- **ND market** = `ROUTE` on the manifests: the two stations sorted alphabetically, non-directional (`CNFGRU`).
  `SEGMENT` is directional (`GRUCNF`). The market list and its domestic or international flag are in `AE_MARKETS`;
  on the manifests, `IS_INTERNATIONAL`. A market missing from `AE_MARKETS` defaults to domestic.
- **True O&D** = `TRUEOD` (`ORG-DST`, first and last station of the passenger's journey). Use it as given.
- **Departure date** = `DATE(STD)`, airport local time. `BOOKINGUTC` is UTC. **NDO** (days before departure) on the
  manifests mixes the two (`.claude/skills/timezone-handling`).
- **History:** manifests are rebuilt for the last 45 days and backfilled up to 800; `PNL_SYSTEMTIMESERIES_BASE` is
  used with 12 to 18 months (full depth not found).
- **Today's bookings are partial:** leave the pull date out on both sides of a comparison.

## 6. Standard exclusions already in the manifests

Azul-operated legs only (`CARRIERCODE = 'AD'`), partner-marketed codeshares out, `CAPACITY >= 5 AND LID >= 5`,
active flight status (`generate_manifests.py`, lines 365 to 388). Not excluded, by flight number: Azul Viagens 2200
to 2599, GOL codeshare 3000 to 3199, Conecta 5100 to 5999, charters 9000 and up. Ask whether to drop them.

## 7. To copy from azul-worker

1. `src/app/services/snowflake/queries/generate_manifests.py`: the whole recipe (fares, LF, prorating, channels).
2. `src/app/services/snowflake/queries/create_manifest_public.py`: the all-in fares.
3. `src/app/models/full_flights_prediction/queries.py`: pulls from the capture time series.
4. `.claude/skills/manifest-seat-status`, `overbooking-gains`, `mai-quantification/reference/fare-components.md`,
   `timezone-handling`: the pitfalls, written by the people who hit them.

## Open issues

- azul-worker's `fare-components.md` says the LF denominator is capacity; its code uses LID. This file follows the
  code.
- No points to BRL value, no booking-date exchange rate, no refund logic found.
