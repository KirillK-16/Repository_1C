
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокПользователей.Параметры.УстановитьЗначениеПараметра("ОбъектКонтроля", Параметры.ОбъектКонтроля);
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Закрыть(Элементы.СписокПользователей.ТекущиеДанные.Пользователь);
КонецПроцедуры
