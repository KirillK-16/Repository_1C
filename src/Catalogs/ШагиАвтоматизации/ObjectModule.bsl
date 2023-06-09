#Область ОбработчикиСобытий

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПометкаУдаления Тогда
		// структура шагов
		НаборЗаписей = РегистрыСведений.СтруктураШаговСценария.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Сценарий.Установить(Владелец);
		НаборЗаписей.Отбор.ИдентификаторШага.Установить(Ссылка);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Сценарий = Владелец;
		НоваяЗапись.ИдентификаторШага = Ссылка;
		НоваяЗапись.Команда = Команда;
		НоваяЗапись.НомерШага = Код;
		НоваяЗапись.УникальныйИдентификаторШага = УникальныйИдентификаторШаблонногоШага;
		НоваяЗапись.ТипШага = ТипШага;
		НоваяЗапись.ВремяНачала = ВремяНачала;
		НоваяЗапись.Использовать = Использовать;
		НоваяЗапись.Оборудование = Оборудование;
		НоваяЗапись.ШаблонОборудования = ШаблонОборудования;
		НоваяЗапись.ОткатываемыйШаг = ОткатываемыйШаг;
		НоваяЗапись.СостояниеШага = Перечисления.СостоянияШаговСценария.НеВыполнялся;
		
		НаборЗаписей.Записать();
	Иначе
		// структура шагов
		НаборЗаписей = РегистрыСведений.СтруктураШаговСценария.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторШага.Установить(Ссылка);
		
		НаборЗаписей.Записать();
		
		// структура параметров
		НаборЗаписей = РегистрыСведений.ПараметрыШаговАвтоматизации.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторШага.Установить(Ссылка);
		
		НаборЗаписей.Записать();

	КонецЕсли;	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//Если НЕ Ссылка.ПометкаУдаления 
	//	И НЕ ПометкаУдаления 
	//	И НЕ ЭтоНовый() 
	//	И НЕ Владелец.Состояние.Пустая() 
	//	И Владелец.Состояние <> Перечисления.СостоянияСценария.НеЗапланирован 
	//	И Владелец.Состояние <> Перечисления.СостоянияСценария.Запланирован Тогда
	//		Отказ = Истина;
	//Иначе
		Если ЗначениеЗаполнено(ОткатываемыйШаг) И ОткатываемыйШаг.Использовать = Ложь Тогда
			Использовать = Ложь;
		КонецЕсли;	
	//КонецЕсли;	
КонецПроцедуры
#КонецЕсли

#КонецОбласти

