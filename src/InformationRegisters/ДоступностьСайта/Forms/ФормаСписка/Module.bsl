
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЭтотОбъект.Параметры.Свойство("Ресурс") Тогда
		ЭтотОбъект.Список.Параметры.УстановитьЗначениеПараметра("Ресурс", ЭтотОбъект.Параметры.Ресурс);
	КонецЕсли;
КонецПроцедуры
