if exists("g:loaded_jira")
        finish
endif
let g:loaded_jira = 1

let s:plugin_name = "jira.nvim"

let s:config_filename = ".jira.json"

function! s:read_file_as_string(filepath)
        let lines = readfile(a:filepath)
        return join(lines, "\n")
endfunction

function s:json_parse(string)
        let [null, false, true] = ['', 0, 1]
        let stripped = substitute(a:string,'\C"\(\\.\|[^"\\]\)*"','','g')
        if stripped !~# "[^,:{}\\[\\]0-9.\\-+Eaeflnr-u \n\r\t]"
                try
                        return eval(substitute(a:string,"[\r\n]"," ",'g'))
                catch
                endtry
        endif
endfunction

function! s:get_config()
        let config_filename = s:config_filename
        let jsonstr = s:read_file_as_string(config_filename)
        let json = s:json_parse(jsonstr)
        return json
endfunction

function! s:file_exists(filepath)
        if filereadable(a:filepath)
                return 1
        else
                return 0
        endif
endfunction

function! s:get_all_jira_links()
        let config =  s:get_config()
	let links_list = config.links
        return links_list
endfunction

function! s:get_all_jira_projects()
        let config =  s:get_config()
	let projects_list = config.projects
        return projects_list
endfunction

function! s:jira_link_completion(linkstring, line, pos)
	let s:links_list = []

	if s:jira_config_available() == 1
		let s:links = s:get_all_jira_links()
		for [key, value] in items(s:links)
			call add(s:links_list, key)
		endfor
	endif

        return filter(s:links_list, 'v:val =~ "^'. a:linkstring .'"')
endfunction

function! s:jira_browse_completion(projectstring, line, pos)
	let s:projects_list = []
	if s:jira_config_available() == 1
		let s:projects = s:get_all_jira_projects()
		for project in s:projects
			call add(s:projects_list, project . '-')
		endfor
	endif
        return filter(s:projects_list, 'v:val =~ "^'. a:projectstring .'"')
endfunction

function! s:exec_external_command(command)
        if has("nvim") == 1
                call jobstart(["bash", "-c", a:command])
        elseif v:version >= 800
                call job_start("bash -c " . a:command)
        else
                silent execute "!" . a:command
        endif
endfunction

function! s:jira_config_available()
	if s:file_exists(s:config_filename)
		return 1
	else
		echom "Jira config not available"
		return 0
	endif
endfunction

function! jira#link(...)
	if s:jira_config_available() == 1
		let s:jira_link_key = ""
		let s:index = 0
		for jira_link_key_seg in a:000
			if s:index != 0
				let s:jira_link_key = s:jira_link_key . " "
			endif
			let s:jira_link_key = s:jira_link_key . jira_link_key_seg
			let s:index += 1
		endfor

		let config =  s:get_config()
		let baseurl = config.baseurl
		let links = config.links
		let jira_link = links[s:jira_link_key]
		let cmd = "xdg-open '" . baseurl . jira_link . "'"
		call s:exec_external_command(cmd)
	endif
endfunction

function! jira#browse(jira_issue_id)
	if s:jira_config_available() == 1
		let config =  s:get_config()
		let baseurl = config.baseurl
		let cmd = "xdg-open " . baseurl . "browse/" . a:jira_issue_id
		call s:exec_external_command(cmd)
	endif
endfunction

function! jira#new()
	if s:jira_config_available() == 1
		let config =  s:get_config()
		let baseurl = config.baseurl
		let cmd = "xdg-open " . baseurl . "secure/CreateIssue!default.jspa"
		call s:exec_external_command(cmd)
	endif
endfunction

command! JiraNew call jira#new()
command! -bang -complete=customlist,s:jira_browse_completion -nargs=* JiraBrowse call jira#browse(<f-args>)
command! -bang -complete=customlist,s:jira_link_completion -nargs=* JiraLink call jira#link(<f-args>)

