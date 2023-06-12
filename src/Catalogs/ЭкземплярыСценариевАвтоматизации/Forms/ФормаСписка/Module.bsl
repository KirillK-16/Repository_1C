#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СтартоватьНаСервере(ВыделенныеСценарии, ТестовыйПрогон)
	Для каждого Сценарий Из ВыделенныеСценарии Цикл
		Если ТипЗнч(Сценарий) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			РаботаСоСценариямиАвтоматизацииСервер.СтартоватьСценарий(Сценарий, ТестовыйПрогон);
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПродолжитьВыполнениеНаСервере(ВыделенныеСценарии)
	Для каждого Сценарий Из ВыделенныеСценарии Цикл
		Если ТипЗнч(Сценарий) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			РаботаСоСценариямиАвтоматизацииСервер.ПродолжитьВыполнениеПрерванногоСценария(Сценарий);
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура Стартовать(Команда)
	Выделенные = Элементы.Список.ВыделенныеСтроки;
	СтартоватьНаСервере(Выделенные, Ложь);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьТест(Команда)
	Выделенные = Элементы.Список.ВыделенныеСтроки;
	СтартоватьНаСервере(Выделенные, Истина);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьСостояниеНаСервере(ВыделенныеСценарии, Состояние, ДатаНач = Ложь, ДатаКон = Ложь)
	Для каждого Сценарий Из ВыделенныеСценарии Цикл
		Если ТипЗнч(Сценарий) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			РаботаСоСценариямиАвтоматизацииСервер.ИзменитьСостояниеСценария(Сценарий, Состояние, ДатаНач, ДатаКон);
		КонецЕсли;		   
	КонецЦикла;	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВернутьКНачальномуСостояниюНаСервере(ВыделенныеСценарии, ТестовыйПрогон)
	Для каждого Сценарий Из ВыделенныеСценарии Цикл
		Если ТипЗнч(Сценарий) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			РаботаСоСценариямиАвтоматизацииСервер.ВернутьСценарийКНачальномуСостоянию(Сценарий, ТестовыйПрогон);
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьКНачальномуСостоянию(Команда)
	Выделенные = Элементы.Список.ВыделенныеСтроки;
	ВернутьКНачальномуСостояниюНаСервере(Выделенные, Ложь);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура Запланировать(Команда)
	Выделенные = Элементы.Список.ВыделенныеСтроки;
	ИзменитьСостояниеНаСервере(Выделенные, ПредопределенноеЗначение("Перечисление.СостоянияСценария.Запланирован"));
	Элементы.Список.Обновить();
КонецПроцедуры 

&НаКлиенте
Процедура ПрерватьЗадание(Команда)
	Выделенные = Элементы.Список.ВыделенныеСтроки;
	ИзменитьСостояниеНаСервере(Выделенные, ПредопределенноеЗначение("Перечисление.СостоянияСценария.Прерван"),,Истина);
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьМастерКопирования(Команда)
	ПараметрыОткрытия = Новый Структура("ЭталонныйСценарий", Элементы.Список.ТекущаяСтрока);
	ОткрытьФорму("Обработка.МастерСозданияЭкземпляровСценария.Форма.ФормаОсновная", ПараметрыОткрытия, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьОтборПоДоступным();	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоДоступным()
	Если Не РаботаСоСценариямиАвтоматизацииПраваДоступа.ПроверитьНаличиеПолногоДоступаКФункционалуАвтоматизации() Тогда
		Ограничения = РаботаСоСценариямиАвтоматизацииПовторноеИспользование.ПолучитьСписокОграниченийДляТекущегоПользователя();
		
		Если Ограничения.Количество() > 0 Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ
			                      |	ЭкземплярыСценариевАвтоматизации.Ссылка КАК Ссылка
			                      |ИЗ
			                      |	Справочник.ЭкземплярыСценариевАвтоматизации КАК ЭкземплярыСценариевАвтоматизации
			                      |ГДЕ
			                      |	ЭкземплярыСценариевАвтоматизации.КонтурАвтоматизации В(&ДоступныеКонтуры)");
			Запрос.УстановитьПараметр("ДоступныеКонтуры", Ограничения);
			
			ОтборСписка = Запрос.Выполнить().Выгрузить();
			
			РаботаСоСценариямиАвтоматизацииПраваДоступа.УстановитьОтборПоДоступнымЭлементамНаСписокФормы(Список, ОтборСписка.ВыгрузитьКолонку("Ссылка"));
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда
		Отказ = Истина;
		ЗапуститьМастерКопирования(Неопределено);
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьЧекЛистНаСервере(Сценарий)
	ТабДок = Новый ТабличныйДокумент;
	
	ЧекЛист = Отчеты.ЧекЛист.Создать();
	ЧекЛист.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = Сценарий;
	ЧекЛист.СкомпоноватьРезультат(ТабДок);
	
	Возврат ТабДок;
КонецФункции

&НаКлиенте
Процедура СформироватьЧекЛист(Команда)
	Если Элементы.Список.ТекущаяСтрока <> Неопределено И ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СправочникСсылка.ЭкземплярыСценариевАвтоматизации") Тогда
		Результат = СформироватьЧекЛистНаСервере(Элементы.Список.ТекущаяСтрока); 
		Результат.Показать();
	Иначе
		ПоказатьПредупреждение(,НСтр("ru='Не выбран экземпляр сценария'"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнение(Команда)
	Выделенные = Элементы.Список.ВыделенныеСтроки;
	ПродолжитьВыполнениеНаСервере(Выделенные);
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти