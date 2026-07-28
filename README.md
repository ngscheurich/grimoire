# Grimoire

Can you hear that? _Shell scripts._ Myriad incantations for your command-line.

## Quickstart

`curl` yourself to enlightenment:

```sh
bash -c "$(curl -fsLS https://raw.githubusercontent.com/ngscheurich/grimoire/main/init.sh)"
```

If this completes successfully, the `grim` command will be at your disposal:

```
Usage: grim [flags] <script>

Executes a grimoire script. If no <script> is provided, a script
chooser will be shown.

Arguments:
  <script>    Name of the script

Flags:
  -h, --help    Show the help message
```

> [!IMPORTANT] Be forewarned
> Some of these scripts require [gum] on your PATH.

Use this power wisely, or don't.

[gum]: https://github.com/charmbracelet/gum
