## Our flow:

First get the right kit-version. 

```bash
cargo install --git https://github.com/hyperware-ai/kit --locked --branch test/pr317-pr318
```
(if it doesn't work, default to my own branch that works):

```bash
cargo install --git https://github.com/hyperware-ai/kit --locked --branch  feat/generate_downstream_types
```

Run:
```bash
./create.sh <parent_directory> <app_name>
```

```<parent_directiory>``` will be created if it does not exist.
```<app_name>``` the name of our vibe-coded application


We then copy the prompt into Claude Code (script copies it into keyboard, then input user input to populate the prompt). If OpenAI API key is availablem could try Codex as well.



