# Pull Request Checklist

Here's what we expect of a good quality pull request. Be sure to follow all these items for a smooth landing!

## Code passes Bitbucket build
Pass all the build tasks, e.g. unit test, linting

## One commit per pull request
This give us the benefit to have a clear and concise git history that clearly and easily documents the changes done and the reasons why.

This is not against "commit early and commit often", just need to squash the commits into a single commit and do a force push when create pull request.

## Include story/task/bug ID in commit message
Having ID in commit will trigger the automated transition in JIRA once the pull request merge into master.

# Write a good Git commit message

## How to Write a Git Commit Message:
* [Git Commit](http://chris.beams.io/posts/git-commit/)
* Separate subject from body with a blank line
* Limit the subject line to 50 characters
* Capitalize the subject line
* Do not end the subject line with a period
* Use the imperative mood in the subject line
* Wrap the body at 72 characters
* Use the body to explain what and why vs. how

## Follow conventional commits:
* [Conventional Commits](https://www.conventionalcommits.org/)
* fix: a commit of the type fix patches a bug in your codebase (this correlates with PATCH in semantic versioning).
* feat: a commit of the type feat introduces a new feature to the codebase (this correlates with MINOR in semantic versioning).
* BREAKING CHANGE: a commit that has the text BREAKING CHANGE: at the beginning of its optional body or footer section introduces a breaking API change (correlating with MAJOR in semantic versioning). A breaking change can be part of commits of any type. e.g., a fix:, feat: & chore: types would all be valid, in addition to any other type.
* Others: commit types other than fix: and feat: are allowed, for example commitlint-config-conventional (based on the the Angular convention) recommends chore:, docs:, style:, refactor:, perf:, test:, and others. We also recommend improvement for commits that improve a current implementation without adding a new feature or fixing a bug. Notice these types are not mandated by the conventional commits specification, and have no implicit effect in semantic versioning (unless they include a BREAKING CHANGE, which is NOT recommended). 
* A scope may be provided to a commit’s type, to provide additional contextual information and is contained within parenthesis, e.g., feat(parser): add ability to parse arrays
