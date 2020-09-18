jira.nvim
=========

A Neovim plugin to make browsing Jira more pleasant.

## Usage

 - `:JiraBrowse OE-1337` to open up a browser with the issue.
 - `:JiraLinks OE-Backlog` to open up a browser with a Jira link.


.jira.json
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

