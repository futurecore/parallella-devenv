# How to produce an animated gif

## Step 1: Record a terminal session

```bash
$ ttyrec myrecording.tty
```

Press `Ctrl+d` when finished.

## Step 2: Convert .tty file to a series of gifs

Make sure that [tty2gif](https://bitbucket.org/antocuni/tty2gif/) is on your `$PATH`.

```bash
$ tty2gif typing myrecording.tty
```

Replays each keypress and takes a screenshot. Don't touch the terminal whilst this is running!

## Step 3: Combine gifs into single file

```bash
$ convert -delay 10 -loop 0 step*.gif -delay 500 $(ls -1 step*.gif | tail -1) -layers Optimize final.gif
```

## Step 4: Tidy up

Rename `final.gif` to something more meaningful. Remove all `step*.gif` files. Add link in `README.md`. Commit.


