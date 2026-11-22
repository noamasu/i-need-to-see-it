# Explaining: from the problem to the mechanism

Two uses. The user asks for an explanation in chat instead of a page ("just explain it", "why is it built this way", "start from the beginning"). And the page's own prose: the Background tab and every step's body are small explanations and follow the same order.

The ask is: **"Give me a better explanation of what we are discussing right now."** The current conversation, or the page just built, supplies the topic. Help the user arrive at an understanding through the situation, observations, and decisions that make it understandable. A correct conclusion can still leave them unable to follow how anyone reached it. Build the missing causal bridges.

## Resolve the current context first

Read the recent exchange and identify the active question, the explanation already given, and the likely missing bridge. If the ask names no subject, apply this to that subject immediately. The context identifies the subject; it does not establish the user's familiarity with that subject. Do not explain the method itself, ask the user to repeat the topic, or restart the investigation unnecessarily. If they name a particular part, focus there. Ask one short clarification only if multiple genuinely plausible subjects remain and context cannot resolve them.

Use the evidence already established. Reframe the explanation rather than repeating the same technical summary at greater length. Retrieve additional facts only when a missing fact materially affects understanding or confidence.

## The penicillin example

This was written for a user who put the ask this way:

> "i would like to be walked through the explanation like i want to understand how the guy discovered penicilin did it for example, what was his pov train of thought and events that led him to the discovery"

They want the rationale behind the story: why something exists, why it is done that way, and where the gaps are. For penicillin, naming the discoverer and announcing the discovery would miss the point. Explain the starting work, what was expected, what was observed instead, why that difference mattered, what questions and experiments followed, and what remained between an initial observation and a useful treatment. Verify historical details and distinguish contributors and stages instead of inventing a seamless lone-genius story.

This is a model for explaining many subjects, not a requirement to mention penicillin in every answer.

## Offer two reading depths

In chat, by default, output **Short version** first, then **Long version**. The user can choose which to read. Honor an explicit request for only one version or a specific length.

Make the short version excellent on its own: establish what the feature or idea is for, give the essential mechanism or event, and connect it to the answer and its significance. For a failure, explain what should work, what breaks, and what that prevents. Preserve any uncertainty that changes the conclusion. Usually one or two compact paragraphs suffice. Choose the few facts that unlock understanding; compress by removing secondary detail, never by packing unexplained jargon into fewer sentences. Prefer component roles and behavior over internal class or method names; reserve implementation names for the long version unless essential and already explained. Do not turn it into a teaser, a bare verdict, or a prerequisite for reading the longer version.

The long version is the coherent learning walkthrough described below. It should also work if the user skips the short version. Give the foundations and causal links room to develop; technical steps and code are welcome. Keep the two versions consistent about causality, scope, and confidence.

## Give a compact learning walkthrough before zooming in

Assume technical competence without assuming knowledge of this particular feature. Working in its repository, recognizing its name, or asking about its test is not evidence that the user knows what it does. Infer the necessary foundations and supply them without turning the conversation into a questionnaire about what they know.

Start far enough back that the specific question has meaning. Build a coherent story from **the real problem → the desired capability → the simplest approach and its limitation → the mechanisms that address that limitation → one normal end-to-end use → the current test, design choice, or failure**. Adapt this progression to the topic; do not force separate headings for every part.

Explain what the feature does for its user, what goes into it, and what useful result comes out. Introduce each mechanism when the story creates a need for it, connecting purpose to operation: what problem does this piece solve, what does it do, and how does that enable the next step? Steps, code, and technical detail are welcome when they advance this same story.

Choose the minimum foundations that make the whole chain understandable. A learning speedrun preserves the causal links while skipping unrelated detail. Before answering, check whether the opening presupposes the very concept the user needs explained. If they explicitly request one narrow detail or brevity, shrink the foundation to what that answer needs.

An example. In a conversation about a failing VM backup test, establish why someone wants a recoverable copy of VM data before describing the test. Explain why making that copy while the VM keeps writing is harder than copying an idle disk; why a stable backup view matters; why tracking changes lets subsequent backups transfer less data; and what the export path lets a backup client obtain. Then introduce the concrete test and the failed handoff. Verify the feature's actual scope instead of implying that a backup test proves a complete restore workflow. Opening with "write A, take a full backup, then take an incremental backup" assumes too much.

## Build the explanation from the reader's starting point

- Establish the concrete situation and goal before introducing the mechanism. What are we trying to accomplish? What would normally happen? Introduce each unfamiliar actor by its job before using its name or acronym.
- Start with what could actually be seen or known then. Avoid giving a person knowledge of the eventual answer before the evidence existed.
- Follow the useful causal sequence: **observation → question → plausible explanation → check → result → revised understanding**. This is a flexible guide, not mandatory headings. Include meaningful surprises and failed explanations when supported by evidence.
- At each turn explain why the observation matters and why the next check or decision makes sense. Chronology alone is insufficient: connect the events.
- For a design, begin with the problem a simpler approach leaves unsolved. Show what each mechanism buys, its tradeoff, and the assumptions under which it works. Distinguish inferred design rationale from documented author intent.
- For a failure, first show the intended successful path, then the exact point where reality diverges. Trace how that produces the visible symptom. Keep symptoms, causes, and contributing weaknesses distinct.

## Keep the story truthful and followable

Present observable evidence, documented reasoning, and concise decision rationales. Label a teaching reconstruction or inference; do not invent private thoughts, dialogue, motives, experiments, or historical events. Do not present a reconstruction as a literal transcript of someone's thinking or of the assistant's internal deliberations.

Use one concrete example throughout. Give markers and placeholders a meaning when introducing them: for example, "the test writes a recognizable text pattern to one disk location; call that original content A." Bare A/B labels are not a substitute for explaining what is actually written and why. Explain unfamiliar concepts before naming their jargon; introduce code after its role is clear. Link evidence and code where they support a specific step. An analogy can bridge an unfamiliar idea, but return to the real mechanism and explain any consequential mismatch.

Write adult, conversational prose. Respect the user's technical competence while supplying missing context. Avoid compressed jargon, disconnected fact lists, theatrical storytelling, and unnecessary detours. Walk through one coherent explanation by default; pause at a natural boundary if it becomes long. Do not require approval or comprehension quizzes after every step. Honor requests for brevity.

Finish with the resulting mental model: why the conclusion follows, why the mechanism exists, and the relevant uncertainty, tradeoff, or unanswered question. Separate what the evidence establishes from what still needs checking.

## Self-check

Does the short version teach the essential idea on its own, with clear cause and effect? Could the user explain what the feature is for and describe one successful use before reaching the test or bug in the long version? Does every essential new term have a role and meaning before it is used to explain something else? Can they explain why the next step was reasonable and predict what changing an important assumption would do? If the answer merely restates the conclusion with more words, add the missing foundation or causal bridge instead.
