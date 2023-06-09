#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередУдалением(Отказ)
	Если ЗначениеЗаполнено(Показатель) Тогда
		УдалениеОбъекта = Новый УдалениеОбъекта(Показатель);
		УдалениеОбъекта.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не Булево(СравниватьСПрошлым) Тогда
		Индекс = ПроверяемыеРеквизиты.Количество() - 1;
		Пока Индекс >= 0 Цикл
			Если ПроверяемыеРеквизиты[Индекс] = "СмещениеБазы" 
				Или ПроверяемыеРеквизиты[Индекс] = "ИнтервалБазы" 
				Или ПроверяемыеРеквизиты[Индекс] = "ЕдиницаВремениИнтервалаБазы" 
				Или ПроверяемыеРеквизиты[Индекс] = "ПорогВПроцентах" 
				Тогда
				ПроверяемыеРеквизиты.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СравниватьСПрошлым Тогда
		ПорогВПроцентах = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПоказателиМониторинга") Тогда
		ЗаполнитьПоПоказателюМониторинга(ДанныеЗаполнения);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоПоказателюМониторинга(Знач ПоказательМониторинга)
	
	ЭтотОбъект.Функция = Перечисления.ФункцииОповещений.Максимум;
	ЭтотОбъект.ИнтервалРасчета = 60;
	ЭтотОбъект.ЕдиницаВремениИнтервалаРасчета = Перечисления.ЕдиницыВремени.Секунда;
	ЭтотОбъект.ВидСравнения = Перечисления.ВидыСравненияПоказателейОповещения.Больше;
	СкопироватьПоказатель(ПоказательМониторинга.Показатель);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СкопироватьПоказатель(ОбъектКопирования.Показатель);
	
КонецПроцедуры

Процедура СкопироватьПоказатель(Знач ИсходныйПоказатель)
	
	Если Не ЗначениеЗаполнено(ИсходныйПоказатель) Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНового = Справочники.ПоказателиОповещений.ПолучитьСсылку();
	УстановитьСсылкуНового(СсылкаНового);
	
	ПоказательОбъект = ИсходныйПоказатель.ПолучитьОбъект().Скопировать();
	ПоказательОбъект.Владелец = СсылкаНового;
	ПоказательОбъект.ОбменДанными.Загрузка = Истина;
	ПоказательОбъект.Записать();
	
	ЭтотОбъект.Показатель = ПоказательОбъект.Ссылка;
	
КонецПроцедуры

#КонецЕсли