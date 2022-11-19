fx_version "cerulean"
game "gta5"

description 'ESX Scoreboard'

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_script 'client/main.lua'

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/listener.js',
	'html/fonts/HarmoniaSansProCyr-Bold.ttf',
	'html/fonts/HarmoniaSansProCyr-Light.ttf',
	'html/fonts/HarmoniaSansProCyr-Regular.ttf'
}


server_export 'GetJobOnlineCount'


exports {
	'GetJobCount'
}