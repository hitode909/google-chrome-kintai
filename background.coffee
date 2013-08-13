wait_tab_load = (tab_id, remain, f) ->
  chrome.tabs.get tab_id, (tab) ->
    console.log tab.status
    if tab.status is 'complete'
      do f
    else
      throw "wait_for_load failed" if remain < 0
      setTimeout ->
        wait_tab_load tab_id, remain-1, f
      , 100

session = (query)->
  kintai_url = localStorage.getItem 'kintai_url'
  unless kintai_url
    alert "URLが設定されていません．オプション画面から設定してください"
    return
  chrome.tabs.create
    url: "#{kintai_url}?#{query}"
  , (tab) ->
      wait_tab_load tab.id, 100, ->
        chrome.tabs.executeScript tab.id,
          file: 'session.js'
          runAt: 'document_end'

check = ->
  now = new Date
  minutes = do now.getMinutes
  hours = do now.getHours
  day = do now.getDay

  up_at   = + localStorage.getItem 'up_at'
  down_at = + localStorage.getItem 'down_at'

  # 毎時0分
  return unless minutes is 0

  # 平日 0 = 日曜日 6 = 月曜日
  return unless 0 < day < 6

  # 出勤
  if hours is up_at
    if confirm "出勤しますか"
      session 'up'

  # 退勤
  if hours is down_at
    if confirm "退勤しますか"
      session 'down'

get_padding = ->
  now = new Date
  (60 - do now.getSeconds) * 1000

check_loop = ->
  do check
  setTimeout check_loop, do get_padding

do check_loop

chrome.runtime.onMessage.addListener (message) ->
  # message: up|down
  session message



CHROME_KEYCONFIG = 'okneonigbfnolfkmfgjmaeniipdjkgkl'
ACTION =
  group: 'kintai'
  actions:[
    {
      name: 'up',
    },
    {
      name: 'down',
    },
  ]

chrome.runtime.sendMessage CHROME_KEYCONFIG, ACTION, (res) ->
  console.log ["res", res]

unless (localStorage.getItem 'login_url') && (localStorage.getItem 'kintai_url')
  chrome.tabs.create
    url: chrome.extension.getURL 'options.html'

