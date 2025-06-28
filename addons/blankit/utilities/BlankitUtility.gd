class_name BlankitUtility extends Node



static func thousands_sep(_number:int, _prefix = ''):
	var _neg = false
	if _number < 0:
		_number = -_number
		_neg = true
	var _string = str(_number)
	var _mod = _string.length() % 3
	var _output = ""
	for _i in range(0, _string.length()):
		if _i != 0 && _i % 3 == _mod:
			_output += ","
		_output += _string[_i]
	if _neg:
		_output = '-' + _prefix + _output
	else:
		_output = _prefix + _output
	return _output
