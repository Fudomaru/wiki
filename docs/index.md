# Welcome to MkDocs

# How I Built My MkDocs Wiki on a Fresh Windows Install

## 1. Installed Python
- Checked with `py --version`
- Added Python to PATH
- Disabled Microsoft Store shortcut trap

## 2. Installed MkDocs
- `pip install mkdocs`
- Ran `mkdocs new .` inside my project folder

## 3. Git & GitHub Setup
- Installed Git with winget
- Set up username + email
- Created GitHub repo and pushed source
- Deployed using `mkdocs gh-deploy`

## 4. Lessons Learned
- Don't trust Windows defaults
- GitHub Pages uses `gh-pages`, not `main`
- Always check your branches and remotes

## 5. What's Next
- Theme upgrade
- First real knowledge sections