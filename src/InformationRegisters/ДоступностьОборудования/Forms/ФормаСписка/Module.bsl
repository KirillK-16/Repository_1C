
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЭтотОбъект.Параметры.Свойство("РабочийСервер") Тогда
		ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("РабочийСервер", ЭтотОбъект.Параметры.РабочийСервер);
	КонецЕсли;
КонецПроцедуры
