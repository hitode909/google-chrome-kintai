var inner, outer;
outer = function() {
  var inner_document, inner_window;
  inner_window = (document.querySelector('frame[src*="CGI"]')).contentWindow;
  inner_document = inner_window.document;
  return inner(inner_window, inner_document)();
};
inner = function(window, document) {
  var ExecModeW, command, find_input, name, password, setCookieParmW;
  name = (document.querySelector('input[type="text"]')).value;
  password = (document.querySelector('input[type="password"]')).value;
  if (!(name.length > 0 && password.length > 0)) {
    alert('社員コードとパスワードを取得できませんでした．10秒後に再度チェックするので社員コードとパスワードを入力してください．');
    setTimeout(function() {
      return inner(window, document);
    }, 10 * 1000);
    return;
  }
  command = location.search.match(/up/) ? 'STR' : 'END';
  find_input = function(form_name, input_name) {
    return (document.querySelector("form[name='" + form_name + "']")).querySelector("input[name='" + input_name + "']");
  };
  setCookieParmW = function() {
    var txt;
    txt = "JOBN=" + (find_input("LANSA", "EZZJOBN")).value + ";";
    txt += "USCD=" + (find_input("LANSA", "AEZZUSCD")).value + ";";
    return window.name = txt;
  };
  ExecModeW = function(SBV, PARM, LSNO, MSGD, LNK) {
    (find_input("LANSA", "AEZZMDID")).value = SBV;
    (find_input("LANSA", "AEZZPARM")).value = PARM;
    (find_input("LANSA", "SEZZLSNO")).value = LSNO;
    return (document.querySelector('form[name="LANSA"]')).submit();
  };
  setCookieParmW();
  return ExecModeW(command, ' ', ' ', '');
};
outer();