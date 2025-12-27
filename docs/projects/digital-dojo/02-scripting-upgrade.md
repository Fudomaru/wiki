---
title: "Scripting Upgrade: A Modular Workflow"
description: "Documenting the refactor of the project's automation scripts to improve maintainability and ease of use."
---

# Scripting Upgrade: A Modular Workflow

This document outlines the recent refactoring of this project's automation scripts. It's a practical step towards building a more robust and professional development workflow.

## The Goal

The primary goal was to improve my personal workflow and to better understand and learn how to build out real-world projects, using what I learned when exploring other projects. The focus was on moving away from monolithic scripts towards a more modular, maintainable, and user-friendly system, guided by the single-purpose principle of good software design.

## The "Before" State

Previously, the project used a single `deploy.sh` script that handled multiple responsibilities:

*   Staging and committing all changes with `git`.
*   Pushing the changes to the remote repository.
*   Activating a Python virtual environment.
*   Deploying the site using `mkdocs gh-deploy`.

While functional, this monolithic approach made the script harder to read, maintain, and extend.

## The "After" State: A Modular System

The scripting infrastructure was completely redesigned into a more logical and powerful system:

*   **`bin/bootstrap.sh`**: A new, powerful "one-liner" script that can set up the entire project on a fresh machine. It handles cloning the repository and running all necessary setup steps. This embodies the goal of "ease of use."

*   **`bin/deploy.sh`**: The main deployment script is now much cleaner. Its sole responsibility is to orchestrate the git workflow (`add`, `commit`, `push`) and then call the dedicated deployment script.

*   **`bin/lib/`**: A new directory that houses a collection of single-purpose helper scripts, each doing one job well:
    *   `check-git.sh`: Verifies that `git` is installed.
    *   `check-python.sh`: Verifies that `python3` is installed.
    *   `install-mkdocs.sh`: Sets up the Python virtual environment and installs all required packages.
    *   `deploy-site.sh`: Handles the logic of running `mkdocs gh-deploy` from the correct virtual environment.

## The Benefits

This new structure provides several key advantages:

*   **Maintainability:** Each script is small, focused, and easy to understand. If the deployment logic changes, I only need to edit `deploy-site.sh`.
*   **Reusability:** The helper scripts in `lib/` can be reused and combined in new ways for future automation tasks.
*   **Robustness:** The `bootstrap.sh` script makes setting up the project on a new computer a reliable and repeatable one-step process.
*   **Clarity:** The entire scripting workflow is now more explicit and easier to follow, which is a hallmark of a professional project.

This refactor was a valuable exercise in applying software engineering principles to a personal project, resulting in a significantly improved development experience.
