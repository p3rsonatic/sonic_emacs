# sonic_emacs
My simple Emacs 30 Configuration - still tweaking and learning
It was mainly made with AI because I hate wasting time with configs.

This Emacs configuration is extremely simple, I even keep the GUI elements and have the package which-key installed to make it easier. It works well as an editor, agenda, personal knowledge management tool, write LaTeX, flashcards and literate programming. It only has the necessary packages installed and has no rebindings so that you do not have to learn anything new. 

My main issue is that it only works on PC, it would be nice if it could be used on the phone but for workflow reasons I am trying to use Emacs and org as a personal knowledge system, but for day to day notes especially with my phone I still use Logseq paired with Syncthing.

<img width="877" height="900" alt="Screenshot From 2025-12-06 20-51-41" src="https://github.com/user-attachments/assets/bf5490f0-cb32-4f31-bfc6-da52ba89d987" />

## Why?

I hate configuring things, to the point that I use GNOME, I think it is "sane engineering", I also hate having to learn tons of keybindings, but Emacs allows maximum expression and somewhat frictionless integration of many workflows. 
Emacs distributions and starter packs sometimes feel verbose, Emacs 30 already has eglot and tree-sitter, and I intend to use it as an editor and personal knowledge system integrated with also my workflow as a medical student, therefore the use of anki-editor (which I am still learning). I used/use Logseq (for notes) + syncthing + LaTeX (for summaries, slides and formal texts) and Emacs allows me to take notes and convert them to LaTeX with some ease, while also allowing me to do flashcards and clozes without much extra effort.


## Packages and dependencies:
Dependency: texlive, anki-connect (anki Add-on code 2055492159)
Packages: org, org-roam, org-babel, anki-editor, Modus Vivendi theme, which-key, eglot, corfu, tree-sitter (note that some packages already come with Emacs 30)

To use it:
- in `(setq dashboard-startup-banner (expand-file-name "~/tardis.png"))` remember to put a tardis.png in your home folder
- also remember in `(org-roam-directory (file-truename "~/Documents/org-notes"))` to set the folder for your org-roam-notes
- and run `org-id-update-id-locations` when first using

# Usage:

## Avoiding shortcuts:

`which-key` and `fido-vertical-mode` allow you to press certain important bindings like `C-c`, `C-x`, `M-x` (Alt + x) and wait for half a second to show all available commands. Also I keep the toolbar and all that activated because the GUI eases entry.

## Org to LaTeX:
- `C-c C-e` Opens export dispatcher menu -> [l] export to LaTeX -> press `o` (as pdf and open) or press `p` (as PDF only)
- Math Block:
  `\begin{equation}
\int_{0}^{\infty} x^2 dx
\end{equation}`
- Math Inline: `$E=mc^2$`
- Heading: `* chapter 1`

## Org Personal Knowledge System
- `M-x` (command search) -> type `dailies` -> choose `org-roam-dailies-capture-today` (emacs creates a file dated today)
- Connecting thoughts like a Wiki: Let's say I am writing a journal and talk about Physiology and I want "Physiology" to be a permanent note: Highlight it -> Press `C-c n i` (create node insert) -> it turns into a link `[[id:xyz][Physiology]]`
- `C-c n f` (node find): search org-roam and jump to a file
- `C-c n i` (node insert): turn the text you are typing right now into a link to another note
- (for those command above you can just `M-x` and type `node` and find the commands like node find, node insert
- `TAB` expands headings (show/hide text)

## Flashcards:

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



## Literate Programming:

(If you do not know literate programming you probably should check Donald Knuth's paper, it is only 15 pages and defines what it is)
(Along with flashcards this is what I am most unfamiliar with, so it may not be as well optimized)
(Note that babel may not have the language of your choice already toggled therefore run `M-x customize-variable org-babel-load-languages` and add the language(s) of your choice

In an .org file you can add:
```
#+begin_src 
#+end_src

```
after src you can add the language to be used.
- To execute the code you run `C-c C-c` inside the code block
- To edit in a native buffer (to have LSP support for example) run `C-c '` then run `C-c '` again to save it
- To **Tangle** (the process of extracting code blocks into a standalone source file) add: `:tangle filename.py` to the header of the block:
```
#+begin_src python :tangle my_script.py
print("Hello from Org!")
#+end_src
```
Then press `C-c C-v t` to generate the file

- Just like the org to LaTeX use, to **Weave** (exporting file to document) you should run the export dispatcher `C-c C-e` press `l` then `p` to export to PDF
Example code:
```
* K&R Literate Programming Guide Test

Test code - A Hello World! in C 

#+begin_src C :exports both
  #include <stdio.h>

  int main (void) {
  printf ("Hello World!\n");
  }
#+end_src

#+RESULTS:
: Hello World!

This code block ran without any issues and outputed "Hello World!".
```
The exported pdf output:
<img width="948" height="841" alt="Screenshot From 2025-12-19 07-53-59" src="https://github.com/user-attachments/assets/6f33789d-a468-41ec-80f1-ddf323094a63" />

# Other recommendations

While highly marketed and quite new, I recommend following the PARA file structure, Project, Area, Resource, Archive. Project being short term projects, Area being things you constantly work on (like university or job), Resource things that you will be using (like books), Archive being stuff you probably won't touch again, but need to keep saved.
I believe org-roam can follow a similar structure, everything descending down 4 nodes each one for P A R A, it gets a falsely hierarchical structure which is easy to read, but can if needed mesh with other nodes in other "branches". What needs to be understood is this, while 2d representations are powerful and are more precise, their complexity and unreadability increases exponentially, that is why we still have 1d representations like tree file systems and prose text instead of concept maps, or even natural 1d languages instead of 2d ones like https://s.ai/nlws/ (Unker Non-Linear Writing System).
