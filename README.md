# sonic_emacs
My simple Emacs 30 Configuration - still tweaking and learning
It was mainly made with AI because I hate wasting time with configs.

## Why?

I hate configuring things, to the point that I use GNOME, I think it is "sane engineering", I also hate having to learn tons of keybindings, but Emacs allows maximum expression and somewhat frictionless integration of many workflows. 
Emacs distributions and starter packs sometimes feel verbose, Emacs 30 already has eglot and tree-sitter, and I intend to use it as an editor and personal knowledge system integrated with also my workflow as a medical student, therefore the use of anki-editor (which I am still learning). I used/use Logseq (for notes) + syncthing + LaTeX (for summaries, slides and formal texts) and Emacs allows me to take notes and convert them to LaTeX with some ease, while also allowing me to do flashcards and clozes without much extra effort.


## Packages and dependencies:
Dependency: texlive, anki-connect (anki Add-on code 2055492159)
Packages: org, org-roam, org-babel, anki-editor, Modus Vivendi theme, which-key.

To use it:
- in `(setq dashboard-startup-banner (expand-file-name "~/tardis.png"))` remember to put a tardis.png in your home folder
- also remember in `(org-roam-directory (file-truename "~/Documents/org-notes"))` to set the folder for your org-roam-notes
- and run `org-id-update-id-locations` when first using

## Usage:

### Avoiding shortcuts:

`which-key` and `fido-vertical-mode` allow you to press certain important bindings like `C-c`, `C-x`, `M-x` (Alt + x) and wait for half a second to show all available commands. Also I keep the toolbar and all that activated because the GUI eases entry.

### Org to LaTeX:
- `C-c C-e` Opens export dispatcher menu -> [l] export to LaTeX -> press `o` (as pdf and open) or press `p` (as PDF only)
- Math Block:
  `\begin{equation}
\int_{0}^{\infty} x^2 dx
\end{equation}`
- Math Inline: `$E=mc^2$`
- Heading: `* chapter 1`

### Org Personal Knowledge System
- `M-x` (command search) -> type `dailies` -> choose `org-roam-dailies-capture-today` (emacs creates a file dated today)
- Connecting thoughts like a Wiki: Let's say I am writing a journal and talk about Physiology and I want "Physiology" to be a permanent note: Highlight it -> Press `C-c n i` (create node insert) -> it turns into a link `[[id:xyz][Physiology]]`
- `C-c n f` (node find): search org-roam and jump to a file
- `C-c n i` (node insert): turn the text you are typing right now into a link to another note
- `TAB` expands headings (show/hide text)

### Flashcards:

Anki cards are just headings with a tag:

```
* Physiology Deck                                        :deck:
:PROPERTIES:
:ANKI_DECK: Physiology
:END:

** Question...                                   :vocab:
answer...
```

Using clozes:

`M-x org-insert-property-drawer` -> Use standard Anki syntax `{{c1::answer}}`
Example:
```
** The Powerhouse of the Cell
:PROPERTIES:
:ANKI_NOTE_TYPE: Cloze
:END:
The {{c1::mitochondria}} is the powerhouse of the cell.
```
Sending to Anki:

To send to Anki: Press `M-x anki-editor-push-tree`

<img width="877" height="900" alt="Screenshot From 2025-12-06 20-51-41" src="https://github.com/user-attachments/assets/bf5490f0-cb32-4f31-bfc6-da52ba89d987" />
