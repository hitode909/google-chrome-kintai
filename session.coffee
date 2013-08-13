outer = ->
  inner_window = (document.querySelector 'frame[src*="CGI"]').contentWindow
  inner_document = inner_window.document

  # window, documentをframe内に差し替え
  do inner inner_window, inner_document

inner = (window, document) ->
  name = (document.querySelector 'input[type="text"]').value
  password =  (document.querySelector 'input[type="password"]').value

  unless name.length > 0 and password.length > 0
    alert '社員コードとパスワードを取得できませんでした．10秒後に再度チェックするので社員コードとパスワードを入力してください．'
    setTimeout ->
      inner window, document
    , 10*1000
    return

  # ?up みたいなURLのとき(backgroudから開くときに指定される)出勤，そうでなければ退勤
  command = if location.search.match(/up/) then 'STR' else 'END'

  # ここの手続は，input[src*=start]とinput[src*=end]のonclickによる
  # document.foo.bar とかできなかったのでquerySelectorを使った形に書き換え
  # あと意味ないifとかあったので消した
  # つらい

  find_input = (form_name, input_name) ->
    (document.querySelector "form[name='#{form_name}']").querySelector "input[name='#{input_name}']"

  setCookieParmW = ->
  	txt = "JOBN=" + (find_input "LANSA", "EZZJOBN").value + ";"
  	txt += "USCD=" + (find_input "LANSA", "AEZZUSCD").value + ";"
  	window.name = txt

  ExecModeW = (SBV, PARM, LSNO, MSGD, LNK) ->
    (find_input "LANSA", "AEZZMDID").value = SBV
    (find_input "LANSA", "AEZZPARM").value = PARM
    (find_input "LANSA", "SEZZLSNO").value = LSNO
    do (document.querySelector 'form[name="LANSA"]').submit

  do setCookieParmW

  ExecModeW command, ' ', ' ', ''

do outer