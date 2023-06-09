////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Объект.ИнтервалУсреднения = Перечисления.ИнтервалыУсреднения.Час;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрОповещения = МониторингСервер.ПараметрОповещенияПоказательЗаписан(ТекущийОбъект);
	ПараметрОповещения.Изменился = ОбъектИзменился();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения.Ссылка = Объект.Ссылка;
	ПараметрОповещения.Описание = Объект.Описание;
	Оповестить("ПоказательЗаписан", ПараметрОповещения, ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ОбъектИзменился()
	
	Если Объект.ИнтервалУсреднения <> Объект.Ссылка.ИнтервалУсреднения Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
