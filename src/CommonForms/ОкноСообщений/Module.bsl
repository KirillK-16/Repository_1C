
&НаКлиенте
Процедура КомандаОК(Команда)
	ЭтотОбъект.Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭтотОбъект.Сообщение = ЭтотОбъект.Параметры.Сообщение;
КонецПроцедуры
