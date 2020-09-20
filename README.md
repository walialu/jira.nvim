jira.nvim
=========

A Neovim plugin to make browsing Jira more pleasant.

## Installation

Via [vim-plug](https://github.com/junegunn/vim-plug):

```text
Plug 'walialu/jira.nvim'
```

### Requirements

[fzf](https://github.com/junegunn/fzf), also installable via `vim-plug`:

```text
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
```

## Usage

 - `:JiraBrowse OE-1337` to open up a browser with the issue.
 - `:JiraLink` to open up a modal window with fuzzy search for links.
 - `:JiraNew` to open up a browser with a new Jira issue.
 - `:JiraOpen` to open up a browser with the base Jira URL.

`JiraBrowse` can be auto-completed via `<tab>`-presses.

## Configuration file

Put a `.jira.json` in the root of your project.

```json
{
	"baseurl": "https://jira.hadcs.de/",
	"projects": [
		"OE",
		"ADM",
		"SDPSD"
	],
	"links": {
		"OE-Kanban-Board": "secure/RapidBoard.jspa?projectKey=OE&rapidView=1912",
		"OE-Backlog": "secure/RapidBoard.jspa?rapidView=1912&projectKey=OE&view=planning.nodetail&issueLimit=100"
	}
}
```

