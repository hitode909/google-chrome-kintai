main = ->
  document.querySelector('#up').onclick = ->
    chrome.runtime.sendMessage null, 'up'

  document.querySelector('#down').onclick = ->
    chrome.runtime.sendMessage null, 'down'

  document.querySelector('a#login').href  = localStorage.getItem 'login_url'

setup = ->
  chrome.tabs.create
    url: chrome.extension.getURL 'options.html'

if (localStorage.getItem 'login_url') && (localStorage.getItem 'kintai_url')
  do main
else
  do setup
