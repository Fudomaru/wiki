---
title: Algorithms to Live By
description: Personal notes on the 12 chapters of Brian Christian & Tom Griffiths' guide to applying computer science thinking to everyday decisions.
---

# Algorithms to Live By

**Author:** Brian Christian & Tom Griffiths
**Genre:** Decision-Making / Applied Computer Science
**Rating:** ⭐⭐⭐⭐⭐

> "The best algorithms are the ones that make the most of the information you have."

## Overview

Twelve chapters, each built around a class of computer science algorithm and the human decisions it maps onto. Not a pop-science feel-good book — the math is real, the implications are practical, and the takeaway is that a lot of what feels like intuition can be made more precise. Immediately applicable to how you structure time, make decisions under uncertainty, and navigate tradeoffs.

---

## Chapter 1 — Optimal Stopping: When to Stop Looking

Life constantly asks you to choose from a sequence: apartments, candidates, offers. The math says: spend the first 37% of your options observing without committing, then take the next one that beats everything you've seen so far. You won't always win, but you'll win more than any other strategy.

The hard part isn't the math — it's the discipline to actually stop exploring and commit.

---

## Chapter 2 — Explore / Exploit: The Tradeoff Between Curiosity and Mastery

Every decision pulls between trying something new (explore) and sticking with what works (exploit). Early in life, explore more — you have time to cash in on what you find. Later, exploit — your horizon is shorter and the compounding matters.

The chapter reframes restlessness and routine as rational responses to time, not personality flaws.

---

## Chapter 3 — Sorting: Order as a Tool, Not a Religion

Sorting is expensive. A perfectly organized system costs more to maintain than it's often worth. The insight: the right amount of organization is the minimum that serves the actual workflow — no more.

Binary search, tournament sorts, and bucket sorts all show up in real life. Knowing which is appropriate beats always defaulting to "tidy everything."

---

## Chapter 4 — Caching: Keep What You Need Close

Every system — your brain, your desk, your file structure — has a memory hierarchy. Frequently accessed things should live at the top. The algorithm is simple: the thing you used most recently is the thing most likely to be needed again.

Practically: stop over-organizing things you use often. Proximity beats taxonomy.

---

## Chapter 5 — Scheduling: Mastering the Queue

When tasks compete for your attention, the order you do them in matters more than most people think. Shortest Job First reduces average wait time. Earliest Deadline First prevents catastrophic lateness. Weighted by importance, these become genuinely useful heuristics for your actual workday.

The chapter also covers context switching — every interrupt has a cost, and batching is almost always worth it.

---

## Chapter 6 — Bayes's Rule: Updating Your Beliefs

Every new piece of information should update your estimate of what's true — and by exactly how much the evidence warrants. Not more, not less. Bayes's Rule is the formal version of "change your mind when the facts change."

The chapter makes a strong case that most human reasoning failures (overconfidence, anchoring, stubbornness) are Bayesian errors.

---

## Chapter 7 — Overfitting: Avoiding the Trap of False Patterns

A model that fits the training data perfectly is often useless in the real world — it's memorized noise instead of learning signal. Humans do the same thing: we build narratives from too little data and hold onto them too long.

The fix is regularization — deliberately constraining how complex your model (or your belief) is allowed to get. Simpler explanations generalize better.

---

## Chapter 8 — Relaxation: Loosening Constraints to Solve Hard Problems

Some problems are computationally impossible to solve exactly. Relaxation algorithms work by temporarily ignoring constraints, solving the easier version, then tightening back up. The relaxed solution becomes a useful bound or starting point.

Applied to life: when you're stuck, try asking "what would I do if this constraint didn't exist?" The answer often reveals a path back.

---

## Chapter 9 — Randomness: When Unpredictability is the Strategy

Randomness isn't just noise — it's a tool. Randomized algorithms can outperform deterministic ones when you have incomplete information or need to avoid adversarial prediction. The chapter covers Monte Carlo methods, simulated annealing, and why sometimes the best move is to shuffle the deck.

The key insight: strategic randomness protects you from being gamed and breaks you out of local optima.

---

## Chapter 10 — Networking: Understanding Systems, Not Just Nodes

Traffic, communication protocols, collaboration — they all follow network dynamics. Braess's Paradox shows that adding capacity to a network can make it slower. The tragedy of the commons is a network problem. Bufferbloat is a scheduling problem disguised as a hardware problem.

The chapter trains you to see the invisible forces that shape collective behavior — and why individual rationality sometimes produces collective failure.

---

## Chapter 11 — Game Theory: Strategy in a World of Others

Most decisions don't happen in isolation — they're moves in a game with other players. Game theory gives you the vocabulary: Nash equilibria, dominant strategies, coordination games, the prisoner's dilemma. Knowing the structure of a situation is half the battle.

The chapter is realistic about limits: not everything is solvable, and sometimes the right move is to change the game entirely.

---

## Chapter 12 — Computational Kindness: Reducing Cognitive Burden for Others

The final chapter reframes courtesy as optimization. Every time you present someone with an open-ended question when a structured choice would do, you've imposed a computation cost on them. Offering defaults, narrowing options, and removing ambiguity is genuinely kind.

It's also the chapter that ties the whole book together: algorithms aren't cold — applied well, they're considerate.

---

## Key Themes

| Theme | Core Idea |
|-------|-----------|
| **Tradeoffs are unavoidable** | Every algorithm optimizes for something at the cost of something else |
| **Context determines strategy** | The right algorithm depends on time horizon, information quality, and stakes |
| **Simplicity generalizes** | Overfitted, overly complex models break under new conditions |
| **Order has a cost** | Perfect organization is often not worth it |
| **Others are part of the system** | Individual optimization can produce collective failure |

---

## Biggest Takeaways

!!! tip "The 37% rule"
    Spend the first 37% of your opportunity window observing. Then commit to the next option that beats everything before it. Applies to jobs, apartments, decisions under time pressure.

!!! info "Explore early, exploit late"
    Your time horizon determines your strategy. When you're young or early in a project, explore aggressively. As the deadline approaches, commit to what works.

!!! warning "You overfit"
    The narratives you build from your experiences are probably too specific. Regularize — hold your conclusions a little more loosely than feels natural.

!!! note "Computational kindness"
    Make decisions easier for the people around you. Propose a specific time instead of "whenever works." Reduce the choices people have to make when a good default exists.
