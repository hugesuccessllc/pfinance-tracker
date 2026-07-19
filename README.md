# Pfinance Tracker

This is todb's Pfinance Tracker, useful for tracking the financial disclosures for candidates for the US House of Representatives. It's a toy for now, mostly to teach myself how robust prompt engineering works. The findings shouldn't be believed without rigorous fact-checking.

Currently, it relies on two major data soruces:

* The FEC
* THe US House Ethics Committee

Each candidate of interest has their disclosures copied here in their respective directories. For example, a candidate for TX-11 named "Pfluger" would end up in `tx-11/august-pfluger`.

This is mostly an experiment in how far I can get with my AI pals. I'll be documenting my process, prompts, and setup as well, so other people can do similar financial spelunking with robot friends.

# License

The code is licensed under the normal [MIT License](https://mit-license.org)

The prose outputs are largely (but not entirely) machine generated. To the extent possible, the prose is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

By submitting a contribution, you grant Huge Success, LLC. a perpetual, worldwide, non-exclusive, irrevocable copyright and patent license to use, modify, distribute, sublicense, and relicense your contribution.

# Process

The below details the process of collecting data.

## The FEC

* Make a directory to store FEC things. For example, for August Pfluger, running in TX-11, it would be:

`mkdir -p tx-11/august-pfluger/fec/`

* Go to https://www.fec.gov/data/
* Seach your candidate's name, and notice active committees, like so:

<img src="images/fec-search.png" width=300>

* Note the committee number you're interested in (in this case, `C00719294`), and make a directory for it: `mkdir -p tx-11/august-pfluger/fec/C00719294`

* Visit the committee page, eg `https://www.fec.gov/data/committee/C00719294/`, and click "Browse Reciepts", once you've checked you're looking at the right year.

<img src="images/committee-page-receipts.png" width=600>

* Click Export, and wait a moment. By default, you're exporting the processed data. Save it to the directory you just made.

* Flip over to Raw data, and do it again. What's the precise difference between "processed" and "raw?" Got me, may as well grab them both, more data is always better, right?

<img src="images/raw-data-export.png" width=600>

* With your browser's back button, go back, and then select "Browse Disbursements," the next section after Receipts.

<img src="images/browse-disbursements.png" width=600>

* Export in the same way; processed, then raw, and save those. You'll want to routinely clear the "Your Downloads" tab because they'll get confusing after about three:

<img src="images/clear-button.png" width=200>

* Take a screenshot of the cash summary, save it, and name it with a timestamp. This will serve as the overall timestamp for this collection. It's a silly way to record a timestamp but machines don't care.

<pre>mv cash-summary.png `date +"%Y-%m-%d-%H-%M-%S-%Z"`-cash-summary.png</pre>

* Move on to the next committee (some candidates have more than one, as seen below).

<img src="images/several-committees.png" width=300>

* Repeat all the above for each commitee, including the cash on hand and timestamp screenshot. Note each committee's ID and create a matching directory.

# Move on to the House Ethics Committee

* Create a directory, `house-ethics` for your candidate or member: `mkdir -p tx-11/august-pfluger/house-ethics`
* Go to https://disclosures-clerk.house.gov/FinancialDisclosure
* Hit Search
* Select Member or Candidate (Member is default)
* Fill in the details.

<img src="images/house-ethics-search.png" width=350>

* Right click on each, "Save Link As" and save them in the `house-ethics` folder.
* Collect each year you're interested in. Note that House races are every two years, so you'll probably want two years' worth of filings.

# Prompts

Now the hard part, the actual data science.

In the old days, we'd use our goop-filled human eyes and read all these boring documents by gaslight.

Then, we got smarter, discovered statistics, then renamed it data science, and built elaborate parsers in R and Python to get through documents like this. But, it still takes forever.

Now, we have access to large language models (LLMs).

The smart way to analyze this stuff is to go through these things would be to leverage our LLM friends to help us write those R and Python parsers to do what we want. This is starting to sound boring agian, though. The [Max Power](https://youtu.be/iVtB7vLRoUo?t=92) way is just ask the LLM to do all the work, then figure out how to prove whatever wild claims it makes. We'll deal with the matter of proof later.

I've got [Visual Studio Code](https://code.visualstudio.com/download) and the [Claude Code for Visual Studio](https://marketplace.visualstudio.com/items?itemName=dliedke.ClaudeCodeExtension) extension, along with a $20/month subscription and a working knowledge of Ruby (my R and Python knowledge is much thinner). Let's go to town.

## Summary generation

This prompt is a reusable template — copy everything from the variable block down to the closing quote, fill in `$CANDIDATE` and `$DISTRICT`, and hand it to a fresh LLM session.

```
CANDIDATE: `Candidate Name`
DISTRICT: `District Name`
```

Every `$CANDIDATE` / `$DISTRICT` below is that same substitution. `$CANDIDATE_DIR` is not filled in separately — derive it from $CANDIDATE and $DISTRICT using the convention already shown in "Process" above (lowercased district + kebab-case candidate name, e.g. `TX-11` + `August Pfluger` → `tx-11/august-pfluger`); if a close-but-not-exact match already exists under `tx-*/`, use that directory instead of creating a new one.

**Prompt history:** the pilot run of this prompt (TX-11/August-Pfluger) shipped a summary with a "Correction (post-publication review)" section — it took a second pass, prompted by a human asking pointed questions, to catch a couple of data-integrity bugs after the fact. Both are now fixed in [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) and documented in its header comments, not repeated here — see the note below on why. This prompt (v2) tells the model to read and reuse that tool up front, specifically so a fresh session doesn't rediscover the same bugs before it can trust its own numbers. A "Correction" section in the output is a sign this prompt or the tool needs another pass, not an acceptable steady state.

**Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed. **Before writing anything new, check whether [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) already exists and covers this candidate's data** (`bundle exec ruby tooling/analyze-candidate.rb --help` shows its interface). It's built to be reused across candidates via `--fec-dir` / `--house-ethics-dir` arguments — extend it in place if a candidate's filings need something it doesn't handle yet, rather than writing a parallel one-off script. **Read that file's header comments in full before trusting or reporting any total** — they hold the specific, tested data-integrity gotchas (duplicate/amended filings, dropped correction rows, lump-sum vendor payments that look unitemized but aren't, and more) as close to the code they explain as possible, so they stay accurate as the tool changes instead of drifting out of sync with a second copy kept here.

**Analyze financial disclosure documents for $CANDIDATE ($DISTRICT) and create an executive summary.**

**Output:**
- Format: Markdown
- Filename: `$CANDIDATE_DIR/README.md`
- Length: Main analysis should be roughly 1,000-1,500 words. The complete Methodology & AI Transparency section (including the full verbatim prompt) doesn't count against this word limit.
- Title: `$DISTRICT: $CANDIDATE — Financial Disclosure Summary`

**Content sections (in this order):**

1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount. Include amounts and donor affiliation where relevant.

2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events). Highlight any unusual or notable expenditures.

3. **Takeaways** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.

4. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis (i.e. this template with $CANDIDATE/$DISTRICT filled in). This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired. If applying `analyze-candidate.rb`'s data-integrity gotchas changed a finding versus a naive read of the data, say so briefly here instead of adding a separate correction section — this prompt already expects that check to happen before publication, not after.

**Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.

**Source:** All data from FEC and House Ethics Committee disclosures in the `$CANDIDATE_DIR/` directory."
